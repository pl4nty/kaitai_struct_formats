# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/modem_config.ksy
meta:
  id: modem_config
  title: 'Micro/WIN project: modem wizard configuration'
  license: MIT
  imports:
    - smart_types
  endian: le

seq:
  - id: index
    type: u2

  - type: u2

  - type: u1
    # valid: 2

  - id: module_command_byte
    type: u4

  - type: u1
  - type: u1

  - id: ctrl_pou
    type: smart_types::strl

  - id: xfr_pou
    type: smart_types::strl

  - id: cfg_pou
    type: smart_types::strl

  - type: smart_types::nulls(1)
