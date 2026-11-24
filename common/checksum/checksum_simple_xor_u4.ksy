meta:
  id: checksum_simple_xor_u4
  title: Simple 32-bit XOR checksum
  license: Unlicense
  endian: le
doc: |
  XOR of all 32-bit words of `data` and `initial`.
  For example, initial 0 and data [1, 2, 4] give 7.
params:
  - id: initial
    type: u4
  - id: data
    type: "u4[]"
instances:
  reduction:
    pos: 0
    size: 0
    type: iteration(_index)
    repeat: expr
    repeat-expr: data.size
  value:
    value: reduction[data.size - 1].res & 0xFFFFFFFF
types:
  iteration:
    params:
      - id: idx
        type: u4
    instances:
      prev:
        value: "idx == 0 ? _root.initial : (_parent.reduction[idx - 1].as<iteration>.res).as<u4>"
      res:
        value: prev ^ _parent.data[idx]
