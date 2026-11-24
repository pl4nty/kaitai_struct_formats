# Imported from https://github.com/AzazelN28/div-tools/blob/188127dfc552063452ff8e092511e6ab77d74823/formats/map.ksy
meta:
  id: div_map
  file-extension: map
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII #cp850
  endian: le

seq:
  - id: header
    type: header
  - id: palette
    type: palette
  - id: n_cpoints
    type: u2
  - id: cpoints
    type: cpoint
    repeat: expr
    repeat-expr: n_cpoints
  - id: pixels
    size: header.width * header.height

enums:
  boolean:
    0: false
    1: true
    
types:
  header:
    seq:
      - id: magic
        contents: ["map",0x1A,0x0D,0x0A,0x00,0x00]
      - id: width
        type: u2
      - id: height
        type: u2
      - id: code
        type: u4
      - id: description
        size: 32
        type: str
  palette:
    seq:
      - id: colors
        type: rgb
        repeat: expr
        repeat-expr: 256
      - id: ranges
        type: range
        repeat: expr
        repeat-expr: 16

    enums:
      range_type:
        0: direct
        1: edit1
        2: edit2
        4: edit4
        8: edit8
    types:
      rgb:
        seq:
          - id: r
            type: u1
          - id: g
            type: u1
          - id: b
            type: u1
      range:
        seq:
          - id: n_colors
            type: u1
          - id: type
            type: u1
            enum: range_type
          - id: fixed
            type: u1
            enum: boolean
          - id: black
            type: u1
          - id: colors
            type: u1
            repeat: expr
            repeat-expr: 32
  cpoint:
    seq:
      - id: x
        type: s2
      - id: 'y'
        type: s2
  
