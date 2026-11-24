# Imported from https://github.com/jharuda/mafia-kaitai-struct/blob/d95ef5d3ef8031410ee3b03d6406f07deb679872/src_ks/mf_rmorf_bin.ksy
meta:
  id: mafia_format_rmorf
  file-extension: rmorf
  license: GPL-3.0-only
  endian: le

seq:
  - id: file_size
    type: u4
  - id: magic_number
    contents: [0xcd, 0xcc, 0xcc, 0x3d]
  - id: morf_count
    type: u4
  - id: morf_desc
    type: morf_desc_t 
    repeat: expr
    repeat-expr: morf_count
  - id: end_byte   # 0x00
    type: u2
    
types:
  morf_desc_t:
    seq:
      - id: mesh_count
        type: u4
      - id: unknown
        type: u4
      - id: frequency
        type: u4
      - id: unknown2
        type: u4
      - id: unknown3
        type: u4
      - id: unknown4
        type: u4
      - id: mesh_desc
        type: mesh_desc_t
        repeat: expr
        repeat-expr: mesh_count
        
  mesh_desc_t:
    seq:
      - id: model_4ds # without .4ds suffix
        type: str
        terminator: 0x2E
        encoding: ASCII
      - id: mesh_name
        type: str
        terminator: 0
        encoding: ASCII
