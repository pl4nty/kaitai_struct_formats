# Imported from https://github.com/aimrebirth/tools/blob/edcc2d8bad7e2d688038a6aaa5bc41552a313c1e/formats/tab.ksy
meta:
  id: aim_db_tab
  title: A.I.M. database table (.tab) file
  license: GPL-3.0-only
  endian: le
  
seq:
  - id: header
    type: tab
  - id: tables
    type: table
    repeat: expr
    repeat-expr: header.n_tables
  - id: fields
    type: field
    repeat: expr
    repeat-expr: header.n_fields

types:
  char20:
    seq:
      - id: str
        size: 0x20
        type: str
        encoding: ASCII

  tab:
    seq:
      - id: n_tables
        type: u4
      - id: n_fields
        type: u4
          
  table:
    seq:
      - id: id
        type: u4
      - id: name
        type: char20
      - id: unk
        type: u4
          
  field:
    seq:
      - id: table_id
        type: u4
      - id: id
        type: u4
      - id: name
        type: char20
      - id: field_type
        type: u4
          
