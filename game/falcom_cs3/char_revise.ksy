# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/char_revise.ksy
meta:
  id: char_revise
  title: Trails of Cold Steel III character stat revision entry
  license: MIT
  encoding: UTF-8
  endian: le
doc: |
  Stat multipliers that apply on top of the global difficulty modifier,
  in percent. Only used for certain enemies and only on Hard and Nightmare.

  Present in t_status.tbl.
seq:
  - id: script
    type: strz
    doc: Enemy script, references status in t_mons.tbl.
  - id: hp
    type: u2
  - id: strength
    type: u2
  - id: defence
    type: u2
  - id: ats
    type: u2
  - id: adf
    type: u2
  - id: speed
    type: u2
  - id: break_multiplier
    type: u2
