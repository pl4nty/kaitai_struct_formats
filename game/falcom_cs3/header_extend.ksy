# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/headers/header_extend.ksy
# Licence and copyright: see _community/README.md
meta:
  id: header_extend
  title: Trails of Cold Steel III extended table header
  license: MIT
  endian: le
seq:
  - id: num_headers
    type: u4
  - id: headers
    type: header_info
    repeat: expr
    repeat-expr: num_headers
types:
  header_info:
    seq:
      - id: header_name
        type: strz
        encoding: UTF-8
      - id: num_entry
        type: u4
