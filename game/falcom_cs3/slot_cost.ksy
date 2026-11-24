# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/slot_cost.ksy
# Licence and copyright: see _community/README.md
meta:
  id: slot_cost
  title: Trails of Cold Steel III slot cost entry
  license: MIT
  endian: le
doc: |
  Cost to unlock orbment slots.

  Present in t_slot.tbl.
seq:
  - id: unlock_position
    type: u2
  - id: slot_level
    type: u2
  - id: earth_sepith_cost
    type: u2
  - id: water_sepith_cost
    type: u2
  - id: wind_sepith_cost
    type: u2
  - id: fire_sepith_cost
    type: u2
  - id: time_sepith_cost
    type: u2
  - id: space_sepith_cost
    type: u2
  - id: mirage_sepith_cost
    type: u2
