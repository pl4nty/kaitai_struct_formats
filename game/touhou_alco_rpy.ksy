# Imported from https://github.com/n-rook/thscoreboard/blob/94c94f2a1d7a4d48d5d63420bea1ed0193ba2f7a/ref/threp-ksy/alco.ksy
# Licence and copyright: see _community/README.md
meta:
  id: touhou_alco_rpy
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
      - id: unknown_2
        size: 16
  stage:
    seq:
      - id: stage_num
        type: u2
      - id: unknown_1
        size: 6
      - id: len_stage_data
        type: u4
      - id: score
        type: u4
      - id: unknown_2
        size: 8
      - id: stage_data
        size: len_stage_data
