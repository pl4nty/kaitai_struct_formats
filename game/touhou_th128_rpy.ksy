# Imported from https://github.com/n-rook/thscoreboard/blob/94c94f2a1d7a4d48d5d63420bea1ed0193ba2f7a/ref/threp-ksy/th128.ksy
meta:
  id: touhou_th128_rpy
  file-extension: raw
  license: Apache-2.0
  endian: le
doc: |
  Decompressed body of a Touhou 128 replay (`.rpy`). On disk, the replay
  starts with the magic `128r`, a u4 version and the common modern header
  (userdata offset, compressed and decompressed sizes; see
  `touhou_modern_rpy`), followed by the encrypted and compressed body and a
  trailing `USER` block. This spec parses the body after decryption and
  decompression; thrpy describes the same body prefixed by the magic and
  header.
doc-ref: https://github.com/hoangcaominh/thrpy/blob/d9ea268b77c7d28419343803b232f932a1dc3a01/ksy/th128.ksy
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
      - id: route
        type: u4
      # ZUN never changes his replay formats...
      - id: subshot_unused
        type: u4
      # If this is 4, then route must be 6
      - id: difficulty
        type: u4
      # Also encodes the route, but encodes the clear status in addition to that
      - id: cleared
        type: u4
      - id: unknown_2
        size: 4
  stage:
    seq:
      - id: stage
        type: u2
      - id: seed
        type: u2
      - id: frames
        type: u4
      - id: len_stage_data
        type: u4
      - id: score
        type: u4
      - id: unknown_0
        type: u4
      - id: piv
        type: u4
      - id: unknown_1
        size: 8
      - id: continues
        type: u4
      - id: unknown_2
        size: 4
      - id: graze
        type: u4
      - id: unknown_3
        size: 84
      - id: motivation
        type: u4
      - id: perfect_freeze
        type: u4
      - id: frozen_area
        type: f4
      - id: unused_1
        size: 4
      - id: stage_data
        size: len_stage_data
