# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3.ksy
meta:
  id: falcom_cs3_tbl
  title: Trails of Cold Steel III table (.tbl) file
  license: MIT
  imports:
    - header_base
    - header_extend
    - cs3_tbl_entry
  encoding: UTF-8
  endian: le
seq:
  - id: header
    type: header_base
  - id: header_extra
    type: header_extend
  - id: entries
    type: cs3_tbl_entry
    repeat: expr
    repeat-expr: header.num_entry
