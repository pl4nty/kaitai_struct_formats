# Imported from https://github.com/n-rook/thscoreboard/blob/94c94f2a1d7a4d48d5d63420bea1ed0193ba2f7a/ref/threp-ksy/th13.ksy
meta:
  id: touhou_th13_rpy
  file-extension: raw
  license: Apache-2.0
  endian: le
doc: |
  Decompressed body of a Touhou 13 replay (`.rpy`). On disk, the replay starts
  with the magic `t13r`, a u4 version and the common modern header (userdata
  offset, compressed and decompressed sizes; see `touhou_modern_rpy`),
  followed by the encrypted and compressed body and a trailing `USER` block.
  This spec parses the body after decryption and decompression; thrpy
  describes the same body prefixed by the magic and header.
doc-ref: https://github.com/hoangcaominh/thrpy/blob/d9ea268b77c7d28419343803b232f932a1dc3a01/ksy/th13.ksy
seq:
  - id: header
    type: header
  - id: stages
    type: stage
    repeat: expr
    repeat-expr: header.stage_count
types:
  header:
    seq:
      - id: name
        size: 12
        type: str
        terminator: 0
        encoding: Shift_JIS
      - id: timestamp
        type: u8
      - id: score
        type: u4
      - id: unknown
        size: 60
      - id: slowdown
        type: f4
      - id: stage_count
        type: u4
      - id: shot
        type: u4
      - id: subshot_unused
        type: u4
      - id: difficulty
        type: u4
      - id: cleared
        type: u4
      - id: unused
        size: 4
      - id: spell_practice_id
        type: u4
  stage:
    seq:
      - id: stage_num
        type: u2
      - id: rng
        type: u2
      - id: frame_count
        type: u4
      - id: len_stage_data
        type: u4
      - id: pos_subpixel_x
        type: u4
      - id: pos_subpixel_y
        type: u4
      - id: shot
        type: u4
      - id: subshot_unused
        type: u4
      - id: score
        type: u4
      - id: unknown
        type: u4
      - id: continues
        type: u4
      - id: unknown2
        type: u4
      - id: graze
        type: u4
      - id: unknown3
        type: u4
      - id: unknown4
        type: u4
      - id: piv
        type: u4
      - id: piv_min
        type: u4
      - id: piv_max
        type: u4
      - id: power
        type: u4
      - id: power_max
        type: u4
      - id: power_min
        type: u4
      - id: lives
        type: u4
      - id: life_pieces
        type: u4
      - id: extends
        type: u4
      - id: bombs
        type: u4
      - id: bomb_pieces
        type: u4
      - id: trance
        type: u4
      - id: unknown5
        type: u4
      - id: focused
        type: u4
      - id: spellcard_real_times
        type: u4
        repeat: expr
        repeat-expr: 21
      - id: stage_data
        size: len_stage_data
