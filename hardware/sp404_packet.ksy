# Imported from https://github.com/iare-digital/open404/blob/294d5cb8278d07295d01c645bca67fb7b158c3a5/specs/sp404_packet.ksy
meta:
  id: sp404_packet
  title: Roland SP-404MKII USB CDC-ACM Packet Framing
  application: Roland SP-404MKII (Firmware v5.51)
  license: MIT
  endian: le

doc: |
  Describes binary packets exchanged across the CDC-ACM virtual serial port
  between host and Roland SP-404MKII sampler.
  Covers 12-byte short commands/triggers and 25-byte parameter updates.

seq:
  - id: magic
    type: u4be
    doc: 4-byte framing magic identifier.
  - id: body
    type:
      switch-on: magic
      cases:
        0x1260e005: short_packet     # Host -> Device short command
        0x12e00005: short_packet     # Device -> Host short acknowledgment
        0x1360e005: param_packet     # Host -> Device parameter update
        0x1360e006: raw_sysex_packet # Host -> Device SysEx filesystem wrapper
        0x13e06006: raw_sysex_packet # Device -> Host SysEx filesystem response
        _: raw_payload

types:
  short_packet:
    seq:
      - id: opcode
        type: u1
        enum: opcode_enum
      - id: target
        type: u1
        doc: Pad index, project index, or sub-opcode
      - id: params
        size: 5
        doc: Command-specific arguments or zero padding
      - id: tail
        type: u1
        doc: Trailing terminator (typically 0x03, 0x05, 0x06, or 0x07)

  param_packet:
    seq:
      - id: target_modifier
        type: u4le
        enum: target_modifier_enum
        doc: Parameter scope (pad parameters, pad selection, global settings)
      - id: tx_id
        type: u4le
        doc: 32-bit incrementing transaction sequence number
      - id: padding
        size: 5
        doc: Fixed framing bytes (typically 09 00 00 00 01)
      - id: param_id
        type: u1
        enum: param_enum
      - id: pad_bytes
        size: 3
        doc: Secondary pad/context bytes (zeros or 0xFF for global settings)
      - id: value
        type: u4le
        doc: 32-bit unsigned/signed parameter value (Little Endian)

  raw_sysex_packet:
    seq:
      - id: data
        type: u1
        repeat: eos

  raw_payload:
    seq:
      - id: data
        type: u1
        repeat: eos

enums:
  opcode_enum:
    0x01: op_exit
    0x02: op_preview_play
    0x03: op_preview_stop
    0x04: op_select_project
    0x06: op_pad_alloc
    0x07: op_pad_copy_swap
    0x08: op_truncate
    0x09: op_normalize
    0x0a: op_emphasis
    0x0b: op_pad_status_query
    0x0c: op_project_init
    0x0d: op_project_info
    0xad: op_pattern_copy
    0xae: op_pattern_move
    0xaf: op_pattern_delete
    0xb0: op_bounce_prepare
    0xb1: op_bounce_execute
    0xfa: op_pad_refresh
    0xfb: op_audio_prep
    0xfc: op_audio_exec
    0xfd: op_audio_import_prep
    0xfe: op_pad_session_lock

  target_modifier_enum:
    0x00007ff7: target_pad_param    # F7 7F 00 00 LE
    0x00007ff8: target_pad_select   # F8 7F 00 00 LE
    0x0000001a: target_settings     # 1A 00 00 00 LE
    0x00000000: target_memory       # 00 00 00 00 LE

  param_enum:
    0x67: param_start_point
    0x68: param_end_point
    0x69: param_level
    0x6a: param_gate
    0x6b: param_loop
    0x6d: param_mute_group
    0x6e: param_bpm_sync
    0x6f: param_bpm
    0x70: param_playback_flags
    0x72: param_one_shot
    0x73: param_pitch_coarse
    0x74: param_pitch_fine
    0x75: param_direction
    0x76: param_time_stretch
    0x77: param_vinyl_mode
    0x78: param_pan
    0x79: param_pad_link
    0x7a: param_bus_fx
    0x7b: param_roll
    0x7d: param_attack
    0x7e: param_hold
    0x7f: param_release
    0x8a: param_groove_type
    0x8b: param_groove_rate
    0x8c: param_groove_humanize
