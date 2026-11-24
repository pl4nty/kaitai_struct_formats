# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/pto_config.ksy
meta:
  id: pto_config
  title: 'Micro/WIN project: PTO wizard configuration'
  license: MIT
  imports:
    - smart_types
  endian: le

seq:
  - type: u4
  - type: u4
  - type: u4

  - id: motor_speed_max
    type: f8

  - id: motor_speed_min
    type: f8

  - type: f8

  - type: u4

  - type: u4
  - id: accel_time_ms
    type: u4

  - id: decel_time_ms
    type: u4

  - type: u4

  - type: u1

  - id: ctrl_pou
    type: smart_types::strl

  - id: man_pou
    type: smart_types::strl

  - id: run_pou
    type: smart_types::strl

  - id: ldpos_pou
    type: smart_types::strl

  - id: afv_pou
    type: smart_types::strl

  - type: u4

  - type: u2
  - type: u2

  - type: u4

  - type: u1
