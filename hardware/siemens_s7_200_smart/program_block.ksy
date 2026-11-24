# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/program_block.ksy
meta:
  id: program_block
  title: 'S7-200 SMART project: program block'
  license: MIT
  imports:
    - pou
  endian: le

seq:
  # - size: 0x0be5
  # - size: 0x0768
  # - size: 0x0af4
  # - size: 0x0a70
  # - size: 0x0a7c
  # - size: 0x6cd

  - id: version
    type: u1
    valid: 2

  - id: num_entries
    type: u2

  - id: pou
    type: pou
    repeat: expr
    repeat-expr: num_entries
