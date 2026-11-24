# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/td_config_mwp.ksy
meta:
  id: td_config_mwp
  title: 'Micro/WIN project: text display wizard configuration'
  license: MIT
  imports:
    - smart_types
  endian: le

seq:
  - type: u1

  - type: u2
  - type: u2
  - type: u1
  - type: u1
  - type: u1
  - type: u1
  - type: u1
  - type: u1
  - type: u1
  - type: u1

  - size: 93

  - id: alarm_pou
    type: smart_types::strl

  - id: ctrl_pou
    type: smart_types::strl

  - type: u2
  - type: u1

  - id: shift_key
    type: smart_types::strl

  - id: num_key
    type: u1

  - type: u4

  - id: key
    type: key
    repeat: expr
    repeat-expr: num_key
    # repeat-expr: 3




types:
  key:
    seq:
      - id: index
        type: u4

      - id: shift
        type: u1

      # - type: u4

      - id: name
        type: smart_types::strl

      - id: name_abbrev
        type: smart_types::strl

      - type: u2
      - type: u4
      - type: u4
      - type: u4
      - type: u4
      - type: u4
      - type: u1
