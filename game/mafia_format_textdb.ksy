# Imported from https://github.com/jharuda/mafia-kaitai-struct/blob/d95ef5d3ef8031410ee3b03d6406f07deb679872/src_ks/mf_textdb_def.ksy
# Licence and copyright: see _community/README.md
meta:
  id: mafia_format_textdb
  file-extension: def
  license: GPL-3.0-only
  endian: le

seq:
  - id: header
    type: header_t
  - id: blocks
    type: block_t
    repeat: expr
    repeat-expr: header.strings_count
  - id: text
    type: str
    terminator: 0
    encoding: ASCII
    repeat: expr
    repeat-expr: header.strings_count

types:
  header_t:
    seq:
      - id: strings_count
        type: u4
      - id: unknow1
        type: u4

  block_t:
    seq:
      - id: id
        type: u4
      - id: offset
        type: u4
