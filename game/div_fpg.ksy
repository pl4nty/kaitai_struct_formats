# Imported from https://github.com/vii1/DIV/blob/3692483012cbdf9c85b2f93f2ae6a35ac4dd193e/formats/fpg.ksy
meta:
  id: div_fpg
  file-extension: fpg
  license: GPL-3.0-only
  encoding: ASCII #cp850
  endian: le

seq:
  - id: header
    type: header
  - id: palette
    type: palette
  - id: maps
    type: map
    repeat: eos

enums:
  boolean:
    0: false
    1: true

types:
  header:
    seq:
      - id: magic
        contents: ["fpg",0x1A,0x0D,0x0A,0]
      - id: version
        type: u1
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
  map:
    seq:
      - id: code
        type: u4
      - id: length
        type: u4
      - id: description
        size: 32
        type: strz
      - id: filename
        size: 12
        type: strz
      - id: width
        type: u4
      - id: height
        type: u4
      - id: n_cpoints
        type: u4
      - id: cpoints
        type: cpoint
        repeat: expr
        repeat-expr: n_cpoints
      - id: pixels
        size: width * height
    types:
      cpoint:
        seq:
          - id: x
            type: s2
          - id: y
            type: s2
