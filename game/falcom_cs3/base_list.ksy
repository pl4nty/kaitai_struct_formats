# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/base_list.ksy
meta:
  id: base_list
  title: Trails of Cold Steel III orbment base list entry
  license: MIT
  imports:
    - character
    - element
  endian: le
doc: |
  Orbment layout: lines and slot restrictions.

  Present in t_orb.tbl.
seq:
  - id: character_id
    type: character
  - id: num_line
    type: u2
  - id: slot1_element
    type: element
  - id: slot2_element
    type: element
  - id: slot3_element
    type: element
  - id: slot4_element
    type: element
  - id: slot5_element
    type: element
  - id: slot6_element
    type: element
  - id: slot7_element
    type: element
