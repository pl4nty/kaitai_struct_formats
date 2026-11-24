# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/orb_line_list.ksy
meta:
  id: orb_line_list
  title: Trails of Cold Steel III orbment line list entry
  license: MIT
  imports:
    - character
  endian: le
doc: |
  Orbment layout: Order of slots.

  Slot ids go from 2 to 8. Slot 2 is the one left of the sub MQ slot, the rest
  are numbered in clockwise order.

  Present in t_orb.tbl.
seq:
  - id: character_id
    type: character
  - id: line_id
    type: u2
  - id: slot1_id
    type: s2
  - id: slot2_id
    type: s2
  - id: slot3_id
    type: s2
  - id: slot4_id
    type: s2
  - id: slot5_id
    type: s2
  - id: slot6_id
    type: s2
  - id: slot7_id
    type: s2
