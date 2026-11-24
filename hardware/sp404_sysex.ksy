# Imported from https://github.com/iare-digital/open404/blob/294d5cb8278d07295d01c645bca67fb7b158c3a5/specs/sp404_sysex.ksy
# Licence and copyright: see _community/README.md
meta:
  id: sp404_sysex
  title: Roland SP-404MKII SysEx Filesystem Protocol
  application: Roland SP-404MKII (Firmware v5.51)
  license: MIT
  endian: le

doc: |
  Describes the SysEx framing protocol used for remote filesystem I/O on the
  SP-404MKII.
  Transfers are wrapped within CDC-ACM magic headers (0x13 0x60 0xe0 0x06
  Host->Dev,
  0x13 0xe0 0x60 0x06 Dev->Host) and bounded by standard MIDI SysEx delimiters (F0
  ... F7).

seq:
  - id: sysex_start
    contents: [0xf0, 0x41]
    doc: MIDI SysEx start (0xF0) and Roland Manufacturer ID (0x41).
  - id: model_id
    type: u1
    doc: Device model identifier (0x7A).
  - id: message_type
    type: u1
    enum: sysex_type_enum
    doc: Sub-type (0x03 = Host Command, 0x7A = Device ACK, 0x02 = Device Data).
  - id: body
    type:
      switch-on: message_type
      cases:
        'sysex_type_enum::host_command': host_command
        'sysex_type_enum::device_ack': device_ack
        'sysex_type_enum::device_data': device_data
        _: raw_sysex_body
  - id: sysex_end
    contents: [0xf7]
    doc: Standard MIDI End-of-Exclusive delimiter (0xF7).

types:
  host_command:
    seq:
      - id: opcode
        type: u1
        enum: sysex_opcode_enum
      - id: tx_id
        type: u4le
        doc: 32-bit transaction sequence ID
      - id: payload
        type:
          switch-on: opcode
          cases:
            'sysex_opcode_enum::open_file': open_file_payload
            'sysex_opcode_enum::close_file': file_handle_payload
            'sysex_opcode_enum::read_file': read_file_payload
            'sysex_opcode_enum::seek_file': seek_file_payload
            'sysex_opcode_enum::stat_file': stat_file_payload
            _: raw_payload

  open_file_payload:
    seq:
      - id: mode_flag
        type: u1
        doc: 0x08 = Read, 0x02 = Write/Create
      - id: padding
        size: 3
      - id: file_path
        type: strz
        encoding: ASCII
        doc: |
          Absolute remote path (e.g.
          /SP404REMOTE///ROLAND\SP-404MKII\PROJECT_01/SMPL\A-01.WAV)

  file_handle_payload:
    seq:
      - id: handle
        type: u1
        doc: Active file handle returned from open_file ACK

  read_file_payload:
    seq:
      - id: handle
        type: u1
      - id: batch_size
        size: 6
        doc: Fixed batch read size (typically 20 00 14 00 00 00)

  seek_file_payload:
    seq:
      - id: handle
        type: u1
      - id: offset_7bit
        size: 3
        doc: 21-bit file offset encoded in MIDI 7-bit bytes
      - id: whence
        type: u1

  stat_file_payload:
    seq:
      - id: padding
        size: 4
      - id: file_path
        type: strz
        encoding: ASCII

  device_ack:
    seq:
      - id: tx_id
        type: u4le
      - id: handle
        type: u1
        doc: Allocated or closed file handle
      - id: padding
        size: 4
      - id: status
        type: u1
        doc: |
          0x08 = Success (Read), 0x02 = Success (Write), 0x00 = Commit/Delete, 0x11 =
          Rejection

  device_data:
    seq:
      - id: tx_id
        type: u4le
      - id: handle
        type: u1
      - id: padding
        size: 5
      - id: data_chunk
        type: u1
        repeat: eos

  raw_payload:
    seq:
      - id: raw_bytes
        type: u1
        repeat: eos

  raw_sysex_body:
    seq:
      - id: raw_bytes
        type: u1
        repeat: eos

enums:
  sysex_type_enum:
    0x03: host_command
    0x7a: device_ack
    0x02: device_data

  sysex_opcode_enum:
    0x00: open_file
    0x03: close_file
    0x04: read_file
    0x06: write_file
    0x07: seek_file
    0x0a: stat_file
    0x0c: open_dir
    0x0d: close_dir
    0x12: query_file
    0x13: get_file_size
