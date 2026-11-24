# Imported from https://github.com/hoangcaominh/thrpy-ksy/blob/68e526d5ef2596027e5bcdbdaf4ea710d31c0969/src/th06.ksy
# Licence and copyright: see _community/README.md
meta:
  id: touhou_th06_rpy
  file-extension: rpy
  license: Apache-2.0
  endian: le
seq:
  - id: header
    type: header
  - id: file_header
    type: file_header
  - id: stages
    type: stage_instance(_index)
    repeat: expr
    repeat-expr: 7
types:
  dummy:
    doc: blank type
  header:
    seq:
      - id: magic
        contents: T6RP
      - id: version
        size: 2
      - id: shot
        type: u1
      - id: difficulty
        type: u1
      - id: checksum
        type: u4
      - id: unknown
        size: 2
      - id: key
        type: u1
  file_header:
    seq:
      - id: unknown_2
        type: u1
      - id: date
        size: 9
        type: str
        terminator: 0x0
        encoding: ASCII
      - id: name
        size: 9
        type: str
        terminator: 0x0
        encoding: Shift_JIS
      - id: unknown_3
        type: u2
      - id: score
        type: u4
      - id: unknown_4
        type: u4
      - id: slowdown
        type: f4
      - id: unknown_5
        type: u4
      - id: stage_offsets
        type: u4
        repeat: expr
        repeat-expr: 7
  stage:
    seq:
      - id: score
        type: u4
      - id: seed
        type: u2
      - id: unknown_1
        type: u2
      - id: power
        type: u1
      - id: lives
        type: s1
      - id: bombs
        type: s1
      - id: rank
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
