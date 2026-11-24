# Imported from https://github.com/hoangcaominh/thrpy-ksy/blob/68e526d5ef2596027e5bcdbdaf4ea710d31c0969/src/th08.ksy
meta:
  id: touhou_th08_rpy
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
    repeat-expr: 9
types:
  dummy:
    doc: blank type
  file_header:
    seq:
      - id: magic
        contents: T8RP
      - id: version
        size: 2
      - id: unknown
        size: 6
      - id: userdata_offset
        type: u4
      - id: unknown_2
        type: u4
      - id: key
        type: u1
      - id: unknown_3
        size: 3
      - id: comp_size
        type: u4
      - id: decomp_size
        type: u4
      - id: stage_offsets
        type: u4
        repeat: expr
        repeat-expr: 9
      - id: potential_stage_size
        type: u4
        repeat: expr
        repeat-expr: 9
  header:
    seq:
      - id: unknown_1
        size: 2
      - id: shot
        type: u1
      - id: difficulty
        type: u1
      - id: date
        size: 6
        type: str
        terminator: 0x0
        encoding: ASCII
      - id: name
        size: 10
        type: str
        terminator: 0x0
        encoding: Shift_JIS
      - id: spell_card_id
        type: u2
      - id: spell_card_name
        size: 50
        type: str
        terminator: 0x0
        encoding: Shift_JIS
      - id: score
        type: u4
      - id: unknown_4
        type: u4
        repeat: expr
        repeat-expr: 25
      - id: slowdown
        type: f4
  stage:
    seq:
      - id: score
        type: u4
      - id: point_items
        type: u4
      - id: graze
        type: u4
      - id: time
        type: u4
      - id: unknown
        type: u4
      - id: piv
        type: u4
      - id: unknown_1
        type: u4
      - id: power
        type: u1
      - id: lives
        type: u1
      - id: bombs
        type: u1
      - id: unknown_2
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
