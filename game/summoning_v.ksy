# Imported from https://github.com/matthewturk/dispersing/blob/7ae6e02d575b01a92955b152376794e9ef13e0f5/dispersing/ksy_files/summoning_v.ksy
meta:
  id: summoning_v
  file-extension: ""
  license: BSD-3-Clause
  endian: le
seq:
  - id: count
    type: u1
  - id: unk1
    type: u1
  - id: unk2
    type: u1
  - id: unk3
    type: u1
  - id: unk4
    type: u1
  - id: rec_info
    type: u2
    repeat: expr
    repeat-expr: count
  - id: records
    type: frecord
    repeat: expr
    repeat-expr: count
types:
  frecord:
    seq:
      - id: col1
        type: u1
      - id: col2
        type: u1
      - id: col3
        type: u1
      - id: col4
        type: u1
      - id: col5
        type: u1
      - id: col6
        type: u1
      - id: col7
        type: u1
      - id: col8
        type: u1
      - id: col9
        type: u1
      - id: col10
        type: u1
      - id: col11
        type: u1
      - id: col12
        type: u1
      - id: col13
        type: u1
      - id: col14
        type: u1
