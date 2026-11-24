# Imported from https://github.com/Game3DEE/darkstone/blob/afc3261693b91fcd371e975889d788dfded04311/src/kaitai/brm.ksy
meta:
  id: darkstone_brm
  file-extension: brm
  license: MIT
  encoding: UTF-8
  endian: le

seq:
  - id: count
    type: u4
  - id: blocks
    type: block
    repeat: expr
    repeat-expr: count

types:
  block:
    seq:
      - contents: [ "INS", 0 ]
      - id: zero4
        type: u4
      - id: name
        size: 60
        type: strz
      - id: float3
        type: f4
        repeat: expr
        repeat-expr: 3
      - id: block_end
        type: u4
