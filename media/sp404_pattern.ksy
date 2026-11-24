# Imported from https://github.com/iare-digital/open404/blob/294d5cb8278d07295d01c645bca67fb7b158c3a5/specs/sp404_pattern.ksy
meta:
  id: sp404_pattern
  title: Roland SP-404MKII Sequencer Pattern Format
  application: Roland SP-404MKII (Firmware v5.51)
  file-extension: bin
  license: MIT
  endian: le

doc: |
  Describes the proprietary 8-byte sequencer event binary file format
  (`PTNXXXXX.BIN`)
  used by the Roland SP-404MKII creative sampler and effector.
  Pattern numbering follows sequentially across banks A-J (16 pads per bank):
  Pattern = (Bank - 'A') * 16 + PadNum (e.g. PTN00001.BIN = Pad A01,
  PTN00160.BIN = Pad J16).

seq:
  - id: header
    size: 16
    doc: |
      16-byte track initialization and synchronization header (starts with 0xFF 0x80
      ... 0xFF 0x80).
  - id: events
    type: pattern_event
    repeat: eos
    doc: Contiguous stream of 8-byte sequencer events until end-of-file.

types:
  pattern_event:
    seq:
      - id: delta_ticks
        type: u1
        doc: Ticks elapsed since the previous event (0-255, 480 PPQ).
      - id: note_target
        type: u1
        doc: Target pad note index or gap advance indicator (0x80).
      - id: velocity_raw
        type: u1
        doc: Velocity with Roland +64 offset (maps 1-127 to 65-191).
      - id: flags
        type: u1
        doc: Sub-timing and event status flags.
      - id: offset
        type: u2
        doc: Cumulative tick offset within the sequence bar.
      - id: gate_ticks
        type: u2
        doc: Gate length / note duration in ticks (480 PPQ, e.g. 480 = 1 quarter note).

    instances:
      is_gap_advance:
        value: note_target == 0x80
        doc: True if this event is an empty time-advance tick spacer for gaps > 255 ticks.
      is_note:
        value: note_target != 0x80
        doc: True if this event is an actual pad note trigger.
      midi_velocity:
        value: velocity_raw - 64
        doc: Normalized standard MIDI velocity (1-127).
      pad_id:
        value: note_target - 47
        if: is_note
        doc: Zero-based internal pad index (0 = Pad A01, 159 = Pad J16).
