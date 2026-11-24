meta:
  id: advanced_installer
  title: Advanced Installer self-extracting setup
  application: Advanced Installer
  file-extension: exe
  license: GPL-3.0-or-later
  ks-version: '0.11'
  encoding: UTF-16LE
  endian: le
doc: |
  The EXE bootstrapper that Advanced Installer builds around one or more
  MSI packages, prerequisites and settings. The files are appended to the
  bootstrapper stub, followed by a table of the files and a 74-byte
  footer that ends with the signature "ADVINSTSFX". An Authenticode
  signature can follow the footer, so the footer is found by searching
  backwards for the signature (Komac searches the last 16 KiB); pass the
  footer's offset (the signature's offset minus 64) as `ofs_footer`.

  Newer versions pack the MSI and the other files into 7z archives
  (`FILES.7z` and `<product>.7z`); older ones store the MSI directly. The
  first 512 bytes of a file whose `xor_flag` is 2 are XORed with 0xFF.
doc-ref:
  - https://github.com/devicie/Komac-anthelion/tree/f9b303df556625ef39215e9c66e08ca037829866/src/analysis/installers/advanced
  - https://github.com/SabreTools/SabreTools.Serialization/blob/main/SabreTools.Data.Models/AdvancedInstaller/Footer.cs
  - https://gist.github.com/KasparNagu/9ee02cb62d81d9e4c7a833518a710d6e
params:
  - id: ofs_footer
    type: u8
    doc: Offset of the footer, 64 bytes before the "ADVINSTSFX" signature.
instances:
  footer:
    pos: ofs_footer
    type: footer
  files:
    pos: footer.ofs_table
    type: file_entry
    repeat: expr
    repeat-expr: footer.num_files
types:
  footer:
    seq:
      - id: reserved
        type: u4
      - id: ofs_footer
        -orig-id: offset
        type: u4
        doc: Offset of this footer in the executable.
      - id: num_files
        type: u4
      - id: version
        type: u4
        doc: 100 in the known installers.
      - id: ofs_info
        -orig-id: info_offset
        type: u4
      - id: ofs_table
        -orig-id: table_pointer
        type: u4
        doc: Offset of the file table.
      - id: ofs_file_data
        -orig-id: file_data_start
        type: u4
        doc: Offset of the first file's data.
      - id: hex_string
        size: 32
        type: str
        encoding: ASCII
        doc: 32 hexadecimal digits, such as an upper-case GUID without dashes.
      - id: unknown
        type: u4
      - id: signature
        contents: ADVINSTSFX
  file_entry:
    seq:
      - id: type_major
        type: u4
        doc: |
          With `type_minor`, the kind of file. Known pairs: 0 3 INI
          settings, 1 0 MSI, 1 1 and 7 1 CAB, 3 7 7z archive of the
          product, 8 6 `FILES.7z`, 1 13 the UI (AIUI), 2 8 `decoder.dll`,
          5 11 and 5 12 DLLs, and 100 8 to 103 8 prerequisites such as
          `vc_redist.x64.exe`.
      - id: type_minor
        type: u4
      - id: xor_flag
        type: u4
        doc: 2 if the start of the file is XORed with 0xFF.
      - id: len_data
        -orig-id: size
        type: u4
      - id: ofs_data
        -orig-id: offset
        type: u4
        doc: Offset of the file's data in the executable.
      - id: len_name
        -orig-id: name_size
        type: u4
        doc: Length of the name in UTF-16 code units.
      - id: name
        size: len_name * 2
        type: str
    instances:
      len_head:
        value: 'xor_flag == 2 ? (len_data < 0x200 ? len_data : 0x200) : 0'
      head:
        io: _root._io
        pos: ofs_data
        size: len_head
        process: xor(0xff)
        if: xor_flag == 2
        doc: The XORed start of the file, decoded.
      tail:
        io: _root._io
        pos: ofs_data + len_head
        size: len_data - len_head
        doc: The rest of the file (the whole file if it is not XORed).
