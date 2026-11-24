# Imported from https://github.com/kotiq/blk/blob/636f1d94ca4f7aaad0f29a76d3dfbbde3f9eef9c/src/formats/game/names.ksy
meta:
  id: dagor_blk_names
  title: Dagor Engine BLK name table
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /common/vlq_base128_le
  endian: le

seq:
  - id: count
    type: vlq_base128_le
  - id: names_data
    type: names_data
    if: count.value != 0

types:
  cstring:
    seq:
      - id: data
        type: strz
        encoding: UTF-8

  names_data:
    seq:
      - id: size
        type: vlq_base128_le
      - id: names_stream
        size: size.value
        type: names_stream

  names_stream:
    seq:
      - id: array
        type: cstring
        repeat: expr
        repeat-expr: _root.count.value
