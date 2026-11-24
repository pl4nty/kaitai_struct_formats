# Imported from https://gist.githubusercontent.com/qguv/129a28225142c7638f547b2e7870ca76/raw/9ddbb5eb2aa556179c6c2457811d4423a319d8c4/ue5_sav.ksy
meta:
  id: pseudoregalia_save
  title: Pseudoregalia save file (GVAS)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Pseudoregalia (Unreal Engine 5) save game. See `unreal_gvas` for the
  generic GVAS save game header.
seq:
  - id: magic
    contents: GVAS
  - id: unknown1
    size: 22
  - id: version
    type: strn
  - id: unknown2
    size: 1268
  - id: blueprint
    type: strn
  - id: props
    type: ntv
    repeat: eos
types:
  strn:
    seq:
      - id: size
        type: u4
      - id: str
        type: strz
        encoding: UTF-8
        if: size > 0
  ustrz:
    seq:
      - id: str
        type: strz
        encoding: UTF-8
  empty:
    seq: []
  ntv:
    seq:
      - id: name
        type: strn
      - id: type
        type: strn
      - id: value
        type:
          switch-on: type.str
          cases:
            '"MapProperty"': map_prop
            '"IntProperty"': int_prop
            '"StrProperty"': str_prop
            '"StructProperty"': struct_prop
            '"ArrayProperty"': array_prop
            '"NameProperty"': str_prop
            '"DoubleProperty"': double_prop
            '"BoolProperty"': bool_prop
  bool_prop:
    seq:
      - id: size
        type: u8
      - id: value
        type: u1
      - id: barrier
        contents: [0]
  double_prop:
    seq:
      - id: size
        type: u8
      - id: barrier
        contents: [0]
      - id: value
        type: f8
  array_prop:
    seq:
      - id: size
        type: u8
      - id: type
        type: strn
      - id: barrier
        contents: [0]
      - id: data
        size: size
        type: array_data
  array_data:
    seq:
      - id: length
        type: u4
      - id: entries
        type:
          switch-on: _parent.type.str
          cases:
            '"NameProperty"': strn
            # TODO '"StructProperty"'
        repeat: expr
        repeat-expr: length
  int_prop:
    seq:
      - id: size
        type: u8
      - id: barrier
        contents: [0]
      - id: value
        type: u4
  str_prop:
    seq:
      - id: size
        type: u8
      - id: barrier
        contents: [0]
      - id: value
        type: strn
  struct_prop:
    seq:
      - id: size
        type: u8
      - id: name
        type: strn
      - id: unknown
        size: 16
      - id: barrier
        contents: [0]
      - id: value
        size: size
  map_prop:
    seq:
      - id: size
        type: u8
      - id: key_type
        type: strn
      - id: value_type
        type: strn
      - id: barrier
        contents: [0]
      - id: data
        size: size
        type: map_data
  map_data:
    seq:
      - id: unknown
        type: u4
      - id: length
        type: u4
      - id: entries
        type: kvp
        repeat: expr
        repeat-expr: length
  kvp:
    seq:
      - id: key
        type: strn
      - id: val
        type: u4
