meta:
  id: installshield_setup_launcher
  title: InstallShield setup launcher overlay
  application: InstallShield
  file-extension: exe
  license: GPL-3.0-or-later
  ks-version: '0.11'
  endian: le
doc: |
  The files that an InstallShield setup launcher (`setup.exe`) carries
  after the end of its PE image (the overlay): `setup.ini`, `setup.iss`,
  `Setup.xml`, the MSI or InstallScript media, prerequisites and so on.
  A launcher whose overlay is empty, or only its Authenticode signature,
  reads them from the folder it is in instead.

  Parse the overlay, starting at the end of the last PE section and ending
  where the Authenticode signature starts. Two layouts are parsed here,
  told apart by the magic of the overlay header: "InstallShield", with
  fixed-size 260-byte ANSI file names, and "ISSetupStream", with UTF-16LE
  names of any length. InstallScript launchers (identified by the
  "ISInternalDescription" or "ProductName" in their version info, not by
  the overlay) use a third layout of null-terminated strings, which is not
  parsed here.

  A file whose flags have bit 1 (encoded) or bit 2 (encoded in 1024-byte
  chunks) set is obfuscated with a key derived from its name and then
  usually zlib-compressed; it is not decoded here. Each byte is
  `~(key[i % len(key)] ^ rotate_left(byte, 4))`, where the key is the
  file name's UTF-8 bytes (as Komac computes it; not the stored UTF-16
  of `ISSetupStream` names) XORed with 13 35 86 07 repeated, and the key index
  restarts for every chunk of a chunked file.
doc-ref:
  - https://github.com/devicie/Komac-anthelion/tree/f9b303df556625ef39215e9c66e08ca037829866/src/analysis/installers/installshield
seq:
  - id: pdb_info
    type: pdb_info
    if: has_pdb_info
  - id: header
    type: header
  - id: files
    type: file(header.header_type, header.magic == "ISSetupStream")
    repeat: expr
    repeat-expr: header.num_files
instances:
  first_bytes:
    pos: 0
    size: 4
  has_pdb_info:
    value: first_bytes == [0x4e, 0x42, 0x31, 0x30]
types:
  pdb_info:
    doc: Optional CodeView PDB 2.0 debug information before the header.
    seq:
      - id: signature
        contents: NB10
      - id: reserved
        size: 12
      - id: pdb_path
        type: strz
        encoding: ASCII
  header:
    seq:
      - id: magic
        size: 14
        type: strz
        encoding: ASCII
        valid:
          any-of:
            - '"InstallShield"'
            - '"ISSetupStream"'
      - id: num_files
        type: u2
      - id: header_type
        type: u4
        doc: 4 if `ISSetupStream` file entries have 24 bytes of attributes.
      - id: reserved
        size: 26
  file:
    params:
      - id: header_type
        type: u4
      - id: is_stream
        type: bool
    seq:
      - id: name_ansi
        size: 260
        type: strz
        encoding: windows-1252
        if: not is_stream
        doc: The file name (`MAX_PATH` bytes).
      - id: len_name
        type: u4
        if: is_stream
        doc: Size of the UTF-16LE file name, in bytes.
      - id: flags
        -orig-id: encoded_flags
        type: u4
        doc: Bit 1 is set if the file is encoded, bit 2 if it is encoded in 1024-byte chunks.
      - id: reserved1
        size: '(is_stream ? 2 : 4)'
      - id: len_data
        type: u4
      - id: reserved2
        size: '(is_stream ? 10 : 40)'
      - id: attributes
        size: 24
        if: is_stream and header_type == 4
      - id: name_utf16
        size: len_name
        type: strz
        encoding: UTF-16LE
        if: is_stream
      - id: data
        size: len_data
    instances:
      name:
        value: 'is_stream ? name_utf16 : name_ansi'
      is_encoded:
        value: (flags & 0b110) != 0
