# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/net_config.ksy
# Licence and copyright: see _community/README.md
meta:
  id: net_config
  title: 'Micro/WIN project: NET wizard configuration'
  license: MIT
  imports:
    - smart_types
  endian: le

seq:
  - type: u1
    valid: 2

  - id: index
    type: u4

  - id: net_exe_pou
    type: smart_types::strl1


  - type: u4
    valid: 1

  - type: u2
    valid: 1

  - id: remote_plc_address
    type: u4

  - id: bytes_to_read
    type: u4

  - type: u2
    valid: 2

  - id: local_plc_address_type
    type: u2
    valid: 0x1002
    # 02 10: VB

  - type: smart_types::nulls(3)

  - id: local_plc_store_address
    type: u4

  - type: u2
    valid: 2

  - id: remote_plc_address_type
    type: u2
    valid: 0x1002
    # 02 10: VB

  - type: smart_types::nulls(3)

  - id: remote_plc_read_address
    type: u4

  - size: 11
    repeat: expr
    repeat-expr: 2

  - type: u4
    valid: 0

  - type: u1
    valid: 1

  - type: u4
    valid: 0

  - type: u4
    valid: 4

  - type: u4
    valid: 0
