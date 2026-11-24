# Imported from https://github.com/jharuda/mafia-kaitai-struct/blob/d95ef5d3ef8031410ee3b03d6406f07deb679872/src_ks/mf_6ds.ksy
meta:
  id: mafia_format_6ds
  file-extension: 6ds
  license: GPL-3.0-only
  endian: le

seq:
  - id: format_singnature
    contents: [0x36, 'D', 'S', 0x00] # 6ds
  - id: file_verion
    type: u2
  - id: timestamp
    type: u8
  - id: vertices_count
    type: u2
  - id: vertex_indices_count
    type: u2
  - id: links_count
    type: u2
  - id: vertices
    type: vector3_float
    repeat: expr
    repeat-expr: vertices_count
  - id: faces
    type: face_t
    repeat: expr
    repeat-expr: vertex_indices_count / 3
  - id: links
    type: link_t
    repeat: expr
    repeat-expr: links_count

types:
  link_t:
    seq:
      - id: vertices_count
        type: u4
      - id: faces_count
        type: u4
      - id: name_length
        type: u1
      - id: name
        size: name_length
        type: str
        encoding: ASCII

  face_t:
    seq:
      - id: vertex_1
        type: u2
      - id: vertex_2
        type: u2
      - id: vertex_3
        type: u2

  vector3_float:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4
      
