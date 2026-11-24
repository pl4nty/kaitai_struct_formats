# Imported from https://github.com/Brachi/albam/blob/6242aaff6c4145732b9b78213f2d7cf9b84d4545/albam/engines/reng/structs/pak.ksy
meta:
  id: reengine_pak
  title: RE Engine archive format
  file-extension: pak
  license: CC0-1.0
  ks-version: '0.11'
  endian: le


seq:
  - {id: ident, contents: [0x4b, 0x50, 0x4b, 0x41]}
  - {id: version, type: u4}
  - {id: num_file_entries, type: u4}
  - {id: reserved, type: u4}
  - {id: file_entries, type: file_entry, repeat: expr, repeat-expr: num_file_entries}

types:
  file_entry:
    seq:
      - {id: file_path_hash_case_insensitive, type: u4}
      - {id: file_path_hash_case_sensitive, type: u4}
      - {id: offset, type: u8}
      - {id: zsize, type: u8}
      - {id: size, type: u8}
      - {id: flags, type: u8}
      - {id: unk_01, type: u8}
