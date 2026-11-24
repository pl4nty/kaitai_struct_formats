# Imported from https://github.com/paulvelzeboer/alfa_romeo_N67/blob/6a7564875b38fbe4d669afb32575dfae1fa57f15/N67.ksy
meta:
  id: alfa_romeo_n67_eeprom
  file-extension: n67.ksy
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: unknown_1
    size: 4
  - id: keys
    type: key
    repeat: expr
    repeat-expr: 7
  - id: unknown_2
    size: 4
  - id: rolling_code_original
    type: u4
  - id: unknown_3
    size: 8 + 16 + 4
  - id: rolling_code_present
    type: u4
  - id: unknown_4
    size: 8 + 16 + 16
  - id: next_load_location
    type: u1
  - id: door_opening_count
    type: u1
  - id: unknown_5
    size: 2
  - id: locked_bits
    type: u1
  - id: unknown_6
    size: 11
instances:
  locked:
    value: locked_bits == 0
  keys_loaded:
    value: next_load_location / 2
  next_key_address:
    value: next_load_location * 2 + 4
  alarm_unlock_code:
    value: keys[keys_loaded-1]
types:
  key:
    seq:
      - id: value
        type: u4
    instances:
      code:
        value: >
          (
            (
              (value & 0x00007000) + ((value & 0x00700000) >> 8)
            ) & 0x7000
          ) +
          (
            (
              ((value & 0x00070000) >> 8) + (value & 0x00000700)
            ) & 0x0700
          ) +
          (
            (
              ((value & 0x70000000) >> 24) + ((value & 0x00700000) >> 16)
            ) & 0x0070
          ) +
          (
            (
              ((value & 0x07000000) >> 24) + ((value & 0x00000700) >> 8)
            ) & 0x0007
          )
