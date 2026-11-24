# Imported from https://github.com/vii1/DIV/blob/3692483012cbdf9c85b2f93f2ae6a35ac4dd193e/formats/fnt.ksy
# Licence and copyright: see _community/README.md
meta:
  id: div_fnt
  file-extension: fnt
  license: GPL-3.0-only
  encoding: ASCII #cp850
  endian: le

seq:
  - id: header
    type: header
  - id: palette
    type: palette
  - id: charset
    size: 4
    type: fnt_charset
  - id: fnt_table
    type: fnt_table
    repeat: expr
    repeat-expr: 256

enums:
  boolean:
    0: false
    1: true

types:
  header:
    seq:
      - id: magic
        contents: ["fnt",0x1A,0x0D,0x0A,0]
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

  fnt_charset:
    seq:
      - id: dummy
        type: b3
      - id: numbers
        type: b1
      - id: uppercase
        type: b1
      - id: lowercase
        type: b1
      - id: symbols
        type: b1
      - id: extended
        type: b1

  fnt_table:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
      - id: inc_y
        type: s4
      - id: offset
        type: u4
    instances:
      image:
        pos: offset
        size: width*height
    
