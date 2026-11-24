# Imported from https://github.com/n-rook/thscoreboard/blob/94c94f2a1d7a4d48d5d63420bea1ed0193ba2f7a/ref/threp-ksy/th12.ksy
meta:
  id: touhou_th12_rpy
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
        terminator: 0x0
        encoding: Shift_JIS
      - id: timestamp
        type: u8
      - id: score
        type: u4
      - id: unknown_1
        size: 60
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
      - id: cleared
        type: u4
      - id: unknown_2
        type: u4
  stage:
    seq:
      - id: stage_num
        type: u2
      - id: seed
        type: u2
      - id: frames
        type: u4
      - id: len_stage_data
        type: u4
      - id: score
        type: u4
      - id: power
        type: u4
      - id: piv
        type: u4
      - id: lives
        type: u2
      - id: life_pieces
        type: u2
      - id: bombs
        type: u2
      - id: bomb_pieces
        type: u2
      - id: ufo_1
        type: u4
      - id: ufo_2
        type: u4
      - id: ufo_3
        type: u4
      - id: unknown_1
        size: 24
      - id: graze
        type: u4
      - id: unknown_2
        size: 88
      - id: stage_data
        size: len_stage_data
