# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/slot_ep.ksy
# Licence and copyright: see _community/README.md
meta:
  id: slot_ep
  title: Trails of Cold Steel III slot EP entry
  license: MIT
  imports:
    - character
  endian: le
doc: |
  Amount of EP gained by unlocking a slot.

  Present in t_slot.tbl.
seq:
  - id: character_id
    type: character
  - id: slot_level
    type: u2
  - id: base_ep
    type: u2
  - id: increase_1
    type: u2
  - id: increase_2
    type: u2
  - id: increase_3
    type: u2
  - id: increase_4
    type: u2
  - id: increase_5
    type: u2
  - id: increase_6
    type: u2
  - id: increase_7
    type: u2
