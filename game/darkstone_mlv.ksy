# Imported from https://github.com/Game3DEE/darkstone/blob/afc3261693b91fcd371e975889d788dfded04311/src/kaitai/mlv.ksy
meta:
  id: darkstone_mlv
  title: Darkstone save-game mesh level format
  application: All DSI Darkstone versions
  file-extension: mlv
  license: MIT
  encoding: ASCII
  endian: le

seq:
  - id: vertex_count
    type: u4
  - id: face_count
    type: u4
  - id: val1
    type: u4
  - id: val2
    type: u4
  - id: vertices
    type: vertex
    repeat: expr
    repeat-expr: vertex_count
  - id: faces
    type: face
    repeat: expr
    repeat-expr: face_count
  - id: map
    type: u4
    repeat: expr
    repeat-expr: 64*64

types:
  vertex:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4
      - id: u1
        type: f4
      - id: u2
        type: u1

  face:
    seq:
      - id: color
        type: u4
      - id: tex_coords
        type: vector2f
        repeat: expr
        repeat-expr: 4
      - id: indices
        type: u2
        repeat: expr
        repeat-expr: 4
      - id: flags
        type: u4
      - id: tex_number
        type: u2

  vector2f:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
