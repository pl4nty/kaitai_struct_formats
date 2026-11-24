# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/pgdat.ksy
meta:
  id: pgdat
  title: PlatinumGames DAT archive
  file-extension:
    - dat
    - pkz
  license: CC0-1.0
  endian: le

doc: |
  PlatinumGames engine flat file archive, magic "DAT\0". Holds parallel
  tables of file offsets, sizes, extensions and (optionally) names.

seq:
  - id: magic
    contents: [0x44, 0x41, 0x54, 0x00]
  - id: file_count
    type: u4
  - id: offset_file_offset_tbl
    type: u4
  - id: offset_file_ext_tbl
    type: u4
  - id: offset_file_name_tbl
    type: u4
  - id: offset_file_size_tbl
    type: u4

instances:
  name_tbl_stride:
    pos: offset_file_name_tbl
    type: u4
    if: offset_file_name_tbl != 0
  offsets:
    pos: offset_file_offset_tbl
    type: u4
    repeat: expr
    repeat-expr: file_count
  sizes:
    pos: offset_file_size_tbl
    type: u4
    repeat: expr
    repeat-expr: file_count
  exts:
    pos: offset_file_ext_tbl
    type: u4
    repeat: expr
    repeat-expr: file_count
    if: offset_file_ext_tbl != 0
  names:
    pos: offset_file_name_tbl + 4
    size: name_tbl_stride
    type: str
    encoding: ASCII
    repeat: expr
    repeat-expr: file_count
    if: offset_file_name_tbl != 0
    doc: |
      Present only when offset_file_name_tbl != 0. name_tbl_stride is a u32
      giving the fixed per-entry name length; names[i] occupies
      offset_file_name_tbl + 4 + i * name_tbl_stride, each a fixed-width
      (possibly NUL-padded) string.
