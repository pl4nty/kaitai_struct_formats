# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/master_quartz_status.ksy
meta:
  id: master_quartz_status
  title: Trails of Cold Steel III master quartz status entry
  license: MIT
  endian: le
doc: |
  Master quartz stat values.

  Present in t_mstqrt.tbl.
seq:
  - id: pattern_id
    type: u1
  - id: master_quartz_level
    type: u2
  - id: hp_increase
    type: u2
  - id: ep_increase
    type: u2
  - id: str_increase
    type: u2
  - id: def_increase
    type: u2
  - id: ats_increase
    type: u2
  - id: adf_increase
    type: u2
  - id: spd_increase
    type: u2
  - id: sub_hp_increase
    type: u2
  - id: sub_ep_increase
    type: u2
  - id: sub_str_increase
    type: u2
  - id: sub_def_increase
    type: u2
  - id: sub_ats_increase
    type: u2
  - id: sub_adf_increase
    type: u2
  - id: sub_spd_increase
    type: u2
