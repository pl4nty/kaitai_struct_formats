# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/quartz_cost.ksy
# Licence and copyright: see _community/README.md
meta:
  id: quartz_cost
  title: Trails of Cold Steel III quartz cost entry
  license: MIT
  endian: le
doc: |
  Quartz synthesis cost.

  Present in t_qu_cost.tbl.
seq:
  - id: quartz_id
    type: u2
  - id: earth_sepith_cost
    type: u2
  - id: water_sepith_cost
    type: u2
  - id: fire_sepith_cost
    type: u2
  - id: wind_sepith_cost
    type: u2
  - id: time_sepith_cost
    type: u2
  - id: space_sepith_cost
    type: u2
  - id: mirage_sepith_cost
    type: u2
