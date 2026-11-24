# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/eth_config.ksy
meta:
  id: eth_config
  title: 'Micro/WIN project: Ethernet wizard configuration'
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

  - id: keep_alive_interval_s
    type: u4

  - type: u1
  - type: u2

  - id: ip_address
    type: smart_types::ipv4_addr

  - id: subnet_mask
    type: smart_types::ipv4_addr

  - id: gateway
    type: smart_types::ipv4_addr

  - id: ctrl_pou
    type: smart_types::strl

  - id: xfr_pou
    type: smart_types::strl

  - id: cfg_pou
    type: smart_types::strl

  - type: smart_types::nulls(5)
