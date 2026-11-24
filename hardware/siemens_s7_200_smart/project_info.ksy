# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/project_info.ksy
meta:
  id: project_info
  title: 'S7-200 SMART project: project information'
  license: MIT
  imports:
    - smart_types
  endian: le

seq:
  # - size: 0x2cf54

  - type: smart_types::nulls(1)

  - id: name
    type: smart_types::strl

  - type: u2
    valid: 0

  - type: u1
    valid: 1

  - type: u4
    valid: 0

  - id: maybe_hash
    size: 16

  - type: u1
    valid: 1

  - type: smart_types::nulls(4)
