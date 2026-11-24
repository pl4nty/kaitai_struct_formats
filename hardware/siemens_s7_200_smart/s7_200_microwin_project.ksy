# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/microwin_project.ksy
meta:
  id: s7_200_microwin_project
  title: Micro/WIN decompressed project data
  license: MIT
  imports:
    - smart_types
    - preamble
    - system_block_mwp
    - program_block
    - symbol_table
    - status_chart
    - data_block
    - cpu_information
    - wizard_data
    - project_info
  endian: le

seq:
  - id: preamble
    type: preamble

  - id: timestamp1a
    type: smart_types::timestamp

  - id: timestamp1b
    type: smart_types::timestamp

  - type: u1
    valid: 0x01

  # TODO: consider whether these timestamps are
  #       part of the system block
  #       maybe also the preceding 0x01 marker
  - id: timestamp1c
    type: smart_types::timestamp
    if: preamble.editor_version >= 0x10

  - id: timestamp1d
    type: smart_types::timestamp
    if: preamble.editor_version >= 0x10

  - id: system_block
    type: system_block_mwp

  - type: u1
    # this is sometimes 1 and sometimes 0
    # not related to version -- not sure what this is

  - id: timestamp2a
    type: smart_types::timestamp

  - id: timestamp2b
    type: smart_types::timestamp

  - id: timestamp2c
    type: smart_types::timestamp

  - id: timestamp2d
    type: smart_types::timestamp

  - id: program_block
    type: program_block

  - id: symbol_table
    type: symbol_table

  - id: status_chart
    type: status_chart

  - id: data_block
    type: data_block

  - id: cpu_information
    type: cpu_information

  - id: wizard_data
    type: wizard_data

  # this block is always at the end
  - id: project_info
    type: project_info

  - id: footer_nulls
    type: smart_types::nulls(16)
