# Imported from https://github.com/shdecompilations/silent-hill-decomp/blob/eb96675c5cb51fe87a66db1df20490c30e5ded6d/docs/file_formats/dat_play.ksy
meta:
  id: silent_hill_demo_play
  title: Silent Hill (PSX) Demo Playback Format
  file-extension: dat
  license: GPL-3.0-only
  encoding: ASCII
  endian: le
  bit-endian: le

doc: |
  DAT is the demo playback format used in Silent Hill. This spec covers all
  `MISC/PLAY****.DAT` files.

instances:
  frames:
    type: frame
    repeat: expr
    repeat-expr: frame_count
    
  frame_count:
    value: _io.size / frame_size

  frame_size:
    value: 16

types:
  frame:
    seq:
      - id: controller_state
        type: controller_state
    
      - id: expected_game_state
        type: s1
    
      - id: video_present_interval
        type: s1
    
      - id: unk_a
        size: 2
    
      - id: rand_seed
        type: u4

  controller_state:
    seq:
      - id: status
        type: u1

      - id: received_bytes
        type: b4

      - id: terminal_type
        type: b4

      - id: button_flags
        type: u2

      - id: right_x
        type: u1

      - id: right_y
        type: u1

      - id: left_x
        type: u1

      - id: left_y
        type: u1
