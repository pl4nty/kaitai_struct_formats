# Imported from https://github.com/hoangcaominh/thrpy-ksy/blob/68e526d5ef2596027e5bcdbdaf4ea710d31c0969/src/th09.ksy
meta:
  id: touhou_th09_rpy
  file-extension: rpy
  license: Apache-2.0
  endian: le
seq:
  - id: file_header
    type: file_header
  - id: header
    type: header
  - id: stages
    type: stage_instance(_index)
    repeat: expr
    repeat-expr: 20
types:
  dummy:
    doc: blank type
  file_header:
    seq:
      - id: magic
        contents: T9RP
      - id: version
        type: u2
      - id: unknown_1
        size: 6
      - id: comp_size
        type: u4
      - id: unknown_2
        type: u4
      - id: key
        type: u1
      - id: unknown_3
        size: 7
      - id: decomp_size
        type: u4
      - id: stage_offsets
        type: u4
        repeat: expr
        repeat-expr: 20
      - id: unknown_offsets
        type: u4
        repeat: expr
        repeat-expr: 20
        doc: |
          These look like more stage offsets, but I have no idea what they do or what
          they're for, and they're causing EOF errors when trying to parse them as stages
          sometimes, so I've chosen to ignore them
  header:
    seq:
      - id: unknown_1
        type: u4
      - id: date
        size: 10
        type: str
        terminator: 0x0
        encoding: ASCII
      - id: name
        size: 9
        type: str
        terminator: 0x0
        encoding: Shift_JIS
      - id: difficulty
        type: u1
  stage:
    seq:
      - id: score
        type: u4
      - id: pair
        type: u2
      - id: shot
        type: u1
      - id: ai
        type: b1
      - id: lives
        type: u1
      - id: unknown
        type: u1
  stage_instance:
    params:
      - id: idx
        type: u4
    instances:
      body:
        pos: _parent.file_header.stage_offsets[idx]
        type:
          switch-on: _parent.file_header.stage_offsets[idx]
          cases:
            0: dummy
            _: stage
