// Parses the SMBIOS table of this Windows machine (GetSystemFirmwareTable 'RSMB')
// or a file, with the C# parsers that ksc generated from firmware/smbios/*.ksy.
//
//   SmbiosDump                      read this machine (Windows)
//   SmbiosDump --save table.bin     also write the raw structure table
//   SmbiosDump FILE                 a raw table (/sys/firmware/dmi/tables/DMI)
//   SmbiosDump --entry-point FILE   a dmidecode --dump-bin file or an entry point
//   add --types 0,1,17 to print only those structure types
using System.Collections;
using System.Reflection;
using System.Runtime.InteropServices;
using Kaitai;

static class Program
{
    [DllImport("kernel32.dll", SetLastError = true)]
    static extern uint GetSystemFirmwareTable(uint provider, uint id, byte[] buffer, uint size);

    static HashSet<int> onlyTypes;
    static readonly HashSet<string> Skip = new() { "M_Root", "M_Parent", "M_Io", "M_RawFormattedArea", "Owner" };

    static int Main(string[] args)
    {
        string file = null, save = null;
        bool entryPoint = false;
        for (int i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--save": save = args[++i]; break;
                case "--entry-point": entryPoint = true; break;
                case "--types": onlyTypes = args[++i].Split(',').Select(int.Parse).ToHashSet(); break;
                default: file = args[i]; break;
            }
        }
        try
        {
            Smbios table;
            if (file == null)
            {
                if (!OperatingSystem.IsWindows()) { Console.Error.WriteLine("Give a file on non-Windows systems."); return 2; }
                const uint RSMB = 0x52534D42;
                uint size = GetSystemFirmwareTable(RSMB, 0, null, 0);
                if (size == 0) throw new InvalidOperationException($"GetSystemFirmwareTable failed: {Marshal.GetLastWin32Error()}");
                var buf = new byte[size];
                GetSystemFirmwareTable(RSMB, 0, buf, size);
                // RawSMBIOSData: Used20CallingMethod, major, minor, DMI revision, u4 length, table.
                int len = BitConverter.ToInt32(buf, 4);
                Console.WriteLine($"SMBIOS {buf[1]}.{buf[2]} (DMI revision {buf[3]}), table {len} bytes");
                var data = buf.AsSpan(8, Math.Min(len, buf.Length - 8)).ToArray();
                if (save != null) { File.WriteAllBytes(save, data); Console.WriteLine($"Saved table to {save}"); }
                table = new Smbios(new KaitaiStream(data));
            }
            else if (entryPoint)
            {
                var ep = new SmbiosEntryPoint(new KaitaiStream(File.ReadAllBytes(file)));
                Print("entry_point", ep, 0);
                table = ep.Body switch
                {
                    SmbiosEntryPoint.EntryPoint32 e => e.Table,
                    SmbiosEntryPoint.EntryPoint64 e => e.Table,
                    SmbiosEntryPoint.LegacyEntryPoint e => e.Table,
                    _ => null,
                };
                if (table == null) { Console.WriteLine("Table is not inside the file."); return 0; }
            }
            else
            {
                table = new Smbios(new KaitaiStream(File.ReadAllBytes(file)));
            }

            Console.WriteLine($"{table.Structures.Count} structures");
            foreach (var s in table.Structures)
            {
                int t = (int)s.Type;
                if (onlyTypes != null && !onlyTypes.Contains(t)) continue;
                string name = Enum.IsDefined(typeof(Smbios.StructureType), s.Type) ? s.Type.ToString() : "oem";
                Console.WriteLine();
                Console.WriteLine($"Handle 0x{s.Handle:X4}, type {t} ({name}), {s.LenFormattedArea} bytes");
                if (s.FormattedArea is byte[] raw) Console.WriteLine($"  raw: {Convert.ToHexString(raw)}");
                else if (s.FormattedArea != null) Print(null, s.FormattedArea, 1);
                if (s.Strings.Count > 1)
                    for (int i = 0; i < s.Strings.Count - 1; i++) Console.WriteLine($"  string {i + 1}: \"{s.Strings[i]}\"");
            }
            return 0;
        }
        catch (Exception e)
        {
            Console.Error.WriteLine($"Parse failed: {e}");
            return 1;
        }
    }

    static void Print(string label, object o, int depth)
    {
        var pad = new string(' ', depth * 2);
        if (label != null) Console.WriteLine($"{pad}{label}:");
        foreach (var p in o.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (Skip.Contains(p.Name) || p.Name.StartsWith("M_Raw") || p.GetIndexParameters().Length > 0) continue;
            object v;
            try { v = p.GetValue(o); }
            catch (TargetInvocationException e) { Console.WriteLine($"{pad}  {p.Name}: <error {e.InnerException?.GetType().Name}: {e.InnerException?.Message}>"); continue; }
            Show(p.Name, v, depth + 1);
        }
    }

    // A struct whose fields are all flags (plus reserved bits) prints as the set flag names.
    static string Flags(KaitaiStruct k)
    {
        var props = k.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => !Skip.Contains(p.Name) && !p.Name.StartsWith("M_Raw") && p.GetIndexParameters().Length == 0).ToList();
        if (props.Count == 0 || props.Any(p => p.PropertyType != typeof(bool) && !p.Name.StartsWith("Reserved"))) return null;
        var set = props.Where(p => p.PropertyType == typeof(bool) && !p.Name.StartsWith("Reserved") && (bool)p.GetValue(k)).Select(p => p.Name);
        return "{" + string.Join(", ", set) + "}";
    }

    static void Show(string name, object v, int depth)
    {
        var pad = new string(' ', depth * 2);
        switch (v)
        {
            case null: return;  // absent (not present in this version)
            case Smbios.StringRef r: Console.WriteLine($"{pad}{name}: {(r.Value == null ? "(none)" : "\"" + r.Value + "\"")}"); break;
            case byte[] b: Console.WriteLine($"{pad}{name}: {Convert.ToHexString(b)}"); break;
            case string s: Console.WriteLine($"{pad}{name}: \"{s}\""); break;
            case Enum e: Console.WriteLine($"{pad}{name}: {(Enum.IsDefined(e.GetType(), e) ? e.ToString() : "0x" + Convert.ToUInt64(e).ToString("X"))}"); break;
            case KaitaiStruct k when k is not Smbios && Flags(k) is string f: Console.WriteLine($"{pad}{name}: {f}"); break;
            case KaitaiStruct k when k is not Smbios: Print(name, k, depth); break;
            case IList list when v is not string:
                Console.WriteLine($"{pad}{name}: [{list.Count}]");
                for (int i = 0; i < list.Count; i++) Show($"[{i}]", list[i], depth + 1);
                break;
            case bool or sbyte or byte or short or ushort or int or uint or long or ulong:
                Console.WriteLine($"{pad}{name}: {v}{(v is bool ? "" : $" (0x{(v is ulong u ? u : unchecked((ulong)Convert.ToInt64(v))):X})")}");
                break;
            default: Console.WriteLine($"{pad}{name}: {v}"); break;
        }
    }
}
