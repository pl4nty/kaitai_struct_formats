# Imported from https://gist.githubusercontent.com/qguv/43531167080c1f941ca8cd8fd77c2bdf/raw/67f2b6cda1ba17fa9d18dd7f28bc67b5d0c4160c/nl2.ksy
meta:
  id: nanoloop2_save
  title: nanoloop two save file
  file-extension: nl2
  license: LicenseRef-All-Rights-Reserved
  ks-version: 0.9
  endian: be
seq:
  - id: data_blocks
    size: 0x100
    type: block
    repeat: expr
    repeat-expr: 60
  - id: metadata_block
    size: 0x100
    type: block
  - id: empty
    size: 0x2ff
  - id: checksum
    type: u1
instances:
  song_name_raw:
    value: |
      metadata_block.name
  file_position:
    value: |
      metadata_block.file_position
  file_version:
    value:
      metadata_block.file_version
types:
  block:
    seq:
      - id: magic0
        contents: [0x24, 0xdb]
      - id: channel
        type: u1
        enum: channel_t
      - id: column
        type: u1
      - id: file_position
        type: u1
      - id: unknown0
        size: 11
      - id: name
        type: u1
        enum: text_t
        repeat: expr
        repeat-expr: 8
      - id: file_version
        size: 3
        type: str
        encoding: ASCII
      - id: unknown1
        size: 5
      - id: data
        size-eos: true
enums:
  channel_t:
    0: r
    1: l
    2: s
    3: n
    4: metadata
  text_t:
    0: 'space'
    1: 'num_0'
    2: 'num_1'
    3: 'num_2'
    4: 'num_3'
    5: 'num_4'
    6: 'num_5'
    7: 'num_6'
    8: 'num_7'
    9: 'num_8'
    10: 'num_9'
    11: a
    12: b
    13: c
    14: d
    15: e
    16: f
    17: g
    18: h
    19: i
    20: j
    21: k
    22: l
    23: m
    24: n
    25: o
    26: p
    27: q
    28: r
    29: s
    30: t
    31: u
    32: v
    33: w
    34: x
    35: y
    36: z
    0x61: special_a
    0x6c: special_l
    0x6e: special_n
    0x6f: special_o
    0x70: special_p
