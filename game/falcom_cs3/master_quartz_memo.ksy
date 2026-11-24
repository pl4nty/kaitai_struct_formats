# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/master_quartz_memo.ksy
meta:
  id: master_quartz_memo
  title: Trails of Cold Steel III master quartz memo entry
  license: MIT
  encoding: UTF-8
  endian: le
doc: |
  Master quartz effect descriptions.

  Present in t_mstqrt.tbl.
seq:
  - id: item_id
    type: u2
  - id: memo_id
    type: u2
  - id: memo_text
    type: strz
