# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/romfs.ksy
meta:
  id: n3ds_romfs
  title: Nintendo 3DS RomFS archive (IVFC)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Nintendo 3DS RomFS archive (.romfs). An IVFC hierarchical-hash container
  wrapping a Level 3 directory/file metadata table. Directory/file metadata
  entry internals (name, sibling/child links, hash-table chaining) are
  walked recursively by RomFS_ReadDirectories() and are not modeled here.
seq:
  - id: magic
    contents: "IVFC"
  - id: magic_number
    type: u4
    doc: Always 0x10000.
  - id: master_hash_size
    type: u4
  - id: level1
    type: level_info
  - id: level2
    type: level_info
  - id: level3
    type: level_info
  - id: optional_info_size
    type: u4
types:
  level_info:
    seq:
      - id: logical_offset
        type: u8
      - id: hash_data_offset
        type: u8
      - id: block_size_log2
        type: u4
      - id: reserved
        type: u4
  level3_header:
    doc: Located at a computed offset after the master hash, block-aligned.
    seq:
      - id: header_length
        type: u4
      - id: dir_hash_table_offset
        type: u4
      - id: dir_hash_table_size
        type: u4
      - id: dir_meta_offset
        type: u4
      - id: dir_meta_size
        type: u4
      - id: file_hash_table_offset
        type: u4
      - id: file_hash_table_size
        type: u4
      - id: file_meta_offset
        type: u4
      - id: file_meta_size
        type: u4
      - id: file_data_offset
        type: u4
