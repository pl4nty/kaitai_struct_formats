# Imported from https://github.com/deefha/klan2016-re/blob/e48e34b7abbc9da902e03c0763f48bb7ede2582f/structs/descriptions.ksy
meta:
  id: klan_descriptions
  title: KLAN descriptions library
  application: KLAN discmag engine
  file-extension: lib
  license: LicenseRef-All-Rights-Reserved
  imports:
    - klan_t_header
  encoding: ASCII
  endian: le

doc-ref: https://wiki.klan2016.cz/knihovny/popisky.html

seq:
  - id: header
    type: klan_t_header
  - id: fat
    type: t_fat
  - id: data
    type: t_data

types:
  t_fat:
    seq:
      - id: foo_1
        type: u4
      - id: foo_2
        type: u4
      - id: foo_3
        type: u4
      - id: foo_4
        type: u4
      - id: offsets
        type: u4
        repeat: expr
        repeat-expr: 8192

  t_data:
    instances:
      descriptions:
        type: t_description(_parent.fat.offsets[_index])
        repeat: expr
        repeat-expr: 8192
      
  t_description:
    params:
      - id: param_offset
        type: u4
    instances:
      content:
        pos: param_offset
        type: t_description_content
        if: param_offset != 0

  t_description_content:
    seq:
      - id: data
        type: t_description_data

  t_description_data:
    seq:
      - id: title
        size: 128
