meta:
  id: dawgdic
  title: dawgdic dictionary (DAWG as double-array)
  application:
    - dawgdic
    - DAWG (Python)
  file-extension: dic
  license: CC0-1.0
  ks-version: '0.11'
  endian: le
doc: |
  Dictionary file of dawgdic, a library that stores a directed acyclic
  word graph (DAWG, a minimal acyclic finite state automaton) in a
  compact double-array. It maps byte-string keys to non-negative
  integer values.

  The file holds the double-array dictionary (a unit count and 32-bit
  units), optionally followed by a guide (a unit count and 2-byte
  units) used for key completion; `dawgdic-build -g` writes a guide,
  `-r` a ranked guide with the same layout. Units are written in host
  byte order; little-endian is assumed.

  Lookup: start at unit 0; to follow label `c` from unit `i`, go to
  `j = i ^ units[i].offset ^ c` and check `units[j].label == c`. A key
  is present if the final unit `has_leaf`; its value is
  `units[i ^ units[i].offset].value`. The guide unit at index `i`
  gives the label of the first child and of the next sibling (0 if
  none).
doc-ref:
  - https://github.com/stil/dawgdic/blob/30be41e480d2612da136b9907d23b569afa10e1a/src/dawgdic/dictionary.h
  - https://github.com/stil/dawgdic/blob/30be41e480d2612da136b9907d23b569afa10e1a/src/dawgdic/dictionary-unit.h
  - https://github.com/stil/dawgdic/blob/30be41e480d2612da136b9907d23b569afa10e1a/src/dawgdic/guide.h
  - https://github.com/stil/dawgdic/blob/30be41e480d2612da136b9907d23b569afa10e1a/src/dawgdic/guide-unit.h
seq:
  - id: num_dictionary_units
    type: u4
  - id: dictionary_units
    type: dictionary_unit
    repeat: expr
    repeat-expr: num_dictionary_units
  - id: guide
    type: guide
    if: not _io.eof
types:
  dictionary_unit:
    seq:
      - id: base
        type: u4
    instances:
      is_leaf:
        value: (base & 0x8000_0000) != 0
        doc: Leaf units hold a value instead of a label/offset.
      value:
        value: base & 0x7fff_ffff
        if: is_leaf
      label:
        value: base & 0xff
        doc: Label of the transition leading to this unit (non-leaf units).
      has_leaf:
        value: (base & 0x100) != 0
        doc: The key ending at this unit has a value.
      is_extended_offset:
        value: (base & 0x200) != 0
      offset:
        value: '(base >> 10) << (is_extended_offset ? 8 : 0)'
        doc: XOR offset to the children of this unit.
  guide:
    seq:
      - id: num_units
        type: u4
      - id: units
        type: guide_unit
        repeat: expr
        repeat-expr: num_units
  guide_unit:
    seq:
      - id: child
        type: u1
        doc: Label of the first child, or 0.
      - id: sibling
        type: u1
        doc: Label of the next sibling, or 0.
