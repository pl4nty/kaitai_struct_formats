# Imported from https://github.com/hoangcaominh/irisu-rpy-struct/blob/88eebb838fe4bc409c3a6aa50588c93c862bd10a/irisu.ksy
meta:
  id: irisu_syndrome_replay
  title: Irisu Syndrome replay
  file-extension: rpy
  license: LicenseRef-All-Rights-Reserved
  endian: le
  bit-endian: le
seq:
  - id: seed
    type: u4
    doc: RNG seed for the replay, taken from DxLib counter
  - id: level
    type: u4
    doc: Highest level reached
  - id: score
    type: u4
    doc: Final score
  - id: chain
    type: u4
    doc: Highest chain reached
  - id: mode
    type: u4
    enum: e_mode
    doc: Game mode.
  - id: padding
    size: 0x20
    doc: Zero padding, ignored
  - id: frames
    size: 4
    type: frame_t
    repeat: eos
    doc: Array of input frames
types:
  frame_t:
    seq:
      - id: left_click
        type: b1
      - id: right_click
        type: b1
      - id: x_pos
        type: b10
      - id: y_pos
        type: b10
enums:
  e_mode:
    0: irisu
    1: metsu
