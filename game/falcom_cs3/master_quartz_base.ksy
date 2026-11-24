# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/master_quartz_base.ksy
meta:
  id: master_quartz_base
  title: Trails of Cold Steel III master quartz base entry
  license: MIT
  endian: le
doc: |
  Master quartz stats.

  Stat patterns refer to values defined under the MasterQuartzStatus header.

  Present in t_mstqrt.tbl.
seq:
  - id: item_id
    type: u2
  - id: master_quartz_id
    type: u2
  - id: unknown
    type: u2
  - id: hp_pattern
    type: u2
  - id: ep_pattern
    type: u2
  - id: str_pattern
    type: u2
  - id: def_pattern
    type: u2
  - id: ats_pattern
    type: u2
  - id: adf_pattern
    type: u2
  - id: spd_pattern
    type: u2
