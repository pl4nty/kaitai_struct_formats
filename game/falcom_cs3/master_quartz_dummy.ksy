# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/master_quartz_dummy.ksy
meta:
  id: master_quartz_dummy
  title: Trails of Cold Steel III master quartz dummy entry
  license: MIT
  endian: le
doc: |
  Mapping "EX" dummy master quartzes to their originals.

  Present in t_mstqrt.tbl.
seq:
  - id: dummy_id
    type: u2
  - id: original_id
    type: u2
