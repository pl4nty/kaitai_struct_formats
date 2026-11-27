# SmbiosDump (test harness, not for merge)

Parses the SMBIOS table of a Windows machine with the C# parsers that ksc
0.11 generates from `firmware/smbios/*.ksy`, and prints every structure.

```sh
# regenerate the parsers (from the repository root)
ksc --target csharp --dotnet-namespace Kaitai --outdir _test/csharp/SmbiosDump/generated \
    --import-path firmware/smbios firmware/smbios/smbios_entry_point.ksy

# build and run (.NET 8 SDK)
cd _test/csharp/SmbiosDump
dotnet run -c Release                          # this machine (Windows, GetSystemFirmwareTable 'RSMB')
dotnet run -c Release -- --save table.bin      # also save the raw table
dotnet run -c Release -- --types 0,1,4,17      # only these types
dotnet run -c Release -- path/to/DMI           # a raw table file
dotnet run -c Release -- --entry-point dump.bin   # a dmidecode --dump-bin file

# a self-contained Windows exe
dotnet publish -c Release -r win-x64 --self-contained -p:PublishSingleFile=true \
    -p:EnableCompressionInSingleFile=true -o publish
```

Limits of the C# output: fields absent in older structure versions, and
conditional instances such as `contained_element.board_type`, show as 0 or
the first enum value rather than null.
