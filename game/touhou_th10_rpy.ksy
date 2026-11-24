# Imported from https://github.com/n-rook/thscoreboard/blob/94c94f2a1d7a4d48d5d63420bea1ed0193ba2f7a/ref/threp-ksy/th10.ksy
# Licence and copyright: see _community/README.md
meta:
  id: touhou_th10_rpy
  file-extension: raw
  license: Apache-2.0
  endian: le
seq:
  - id: header
    type: header
  - id: stages
    type: stage
    repeat: expr
    repeat-expr: header.stagecount
types:
  header:
    seq:
      - id: name
        size: 12
        type: str
        encoding: Shift_JIS
      - id: timestamp
        type: u4
      - id: score
        type: u4
      - id: unknown_1
        size: 52
      - id: slowdown
        type: f4
      - id: stagecount
        type: u4
      - id: shot
        type: u4
      - id: subshot
        type: u4
      - id: difficulty
        type: u4
      - id: unknown_3
        type: u4
      - id: unknown_4
        type: u4
  stage:
    seq:
      - id: stage_num
        type: u2
      - id: unknown_1
        type: u2
      - id: unknown_2
        type: u4
      - id: len_stage_data
        type: u4
        doc: add to current stage offset, + current stage header length which is 0x1c4
      - id: score
        type: u4
      - id: power
        type: u4
      - id: piv
        type: u4
      - id: unknown_3
        type: u4
      - id: lives
        type: u4
      - id: rest_of_header
        size: 420
      - id: stage_data
        size: len_stage_data
