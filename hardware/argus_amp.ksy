# Imported from https://github.com/p-fruck/argus-tools/blob/55953d692e3d2824eb89c19aa43adc0ecb245a8d/src/argus_amp.ksy
# Licence and copyright: see _community/README.md
meta:
  id: argus_amp
  title: Argus AMP
  file-extension: amp
  license: AGPL-3.0-only
  endian: le

seq:
  - id: magic_bytes
    size: 6
  - id: protocol_string
    size: 64
    type: str
    encoding: ISO-8859-1
  - id: reserved_header
    size: 5659
  - id: len_meta
    type: u1
  - id: meta
    size: len_meta
    type: meta
  - id: measurement_name
    size: 25
    type: strz
    encoding: ISO-8859-1
    doc: |
      The name of the measurement file. Allows for
      24 characters and a terminating null-byte.
  - id: unknown3
    size: 4
  - id: padding
    size: 130
  - id: owner
    type: owner
  - id: test_type
    size: 4
  - id: unknown8
    size: 9
    terminator: 0
  - id: data
    type:
      switch-on: test_type
      cases:
        '[0x5e, 0x40, 0xd8, 0x00]': tdr_data
        '[0xfb, 0x30, 0xde, 0x00]': cb_data
        '[0x31, 0x00, 0x50, 0x02]': dsl_data
types:
  cb_data:
    seq:
      - id: unknown
        size-eos: true
  dsl_data:
    seq:
      - id: unknown
        size-eos: true
  tdr_data:
    seq:
      - id: tdr_info
        type: tdr_info
      - id: cable_name
        size: 25
        type: strz
        encoding: ISO-8859-1
      - id: unknown6
        size: 24
      - id: tdr_range
        type: u4
      - id: unknown7
        size: 19
      - id: curve_data
        type: tdr_curve_block
      - id: raw_pulse
        type: tdr_pattern_block
  firmware:
    doc: Argus firmware version
    seq:
      - id: major
        type: u1
      - id: minor
        type: u1
      - id: patch
        type: u1
      - id: suffix
        type: u1
  datetime:
    doc: The datetime at which the measurement was taken
    seq:
      - id: second
        type: u1
      - id: minute
        type: u1
      - id: hour
        type: u1
      - id: day
        type: u1
      - id: month
        type: u1
      - id: year
        type: u2
  meta:
    seq:
      - id: firmware
        type: firmware
      - id: unknown1
        size: 4
      - id: serial_number
        type: u2
      - id: unknown2
        size: 8
      - id: datetime
        type: datetime
  owner:
    doc: Ownership information of the Argus device
    seq:
      - id: organization
        size: 64
        type: strz
        encoding: ISO-8859-1
      - id: address1
        size: 64
        type: strz
        encoding: ISO-8859-1
      - id: postal_code
        size: 64
        type: strz
        encoding: ISO-8859-1
      - id: phone
        size: 64
        type: strz
        encoding: ISO-8859-1
  tdr_curve_block:
    seq:
      - id: samples
        type: s2
        repeat: expr
        repeat-expr: 4096
  tdr_info:
    seq:
      - id: gain_raw
        type: u1
      - id: pulse_width_lo
        type: u1
      - id: pulse_width_hi
        type: u1
      - id: pulse_height
        type: u2
      - id: unknown_tdr_info1
        size: 2
      - id: v2_raw
        type: u1
      - id: unknown_tdr_info2
        size: 1
    instances:
      pulse_width_ns:
        value: gain_raw | (pulse_width_lo << 8)
  tdr_pattern_block:
    seq:
      - id: samples
        type: u2
        repeat: expr
        repeat-expr: 4096
