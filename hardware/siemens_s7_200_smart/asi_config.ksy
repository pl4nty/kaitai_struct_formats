# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/asi_config.ksy
# Licence and copyright: see _community/README.md
meta:
  id: asi_config
  title: 'Micro/WIN project: AS-i wizard configuration'
  license: MIT
  imports:
    - smart_types
  endian: le

seq:
  - type: u4

  - type: u1
    # valid: 2

  - id: maybe_crc
    type: u4

  - type: u1

  - size: 11
    repeat: expr
    repeat-expr: 6

  - type: u4
    repeat: expr
    repeat-expr: 6

  - id: ctrl_pou
    type: smart_types::strl

  - id: write_pou
    type: smart_types::strl

  - id: read_pou
    type: smart_types::strl

  - type: smart_types::nulls(5)
