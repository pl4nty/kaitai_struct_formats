# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/status_revise.ksy
# Licence and copyright: see _community/README.md
meta:
  id: status_revise
  title: Trails of Cold Steel III status revision entry
  license: MIT
  imports:
    - difficulty
  encoding: UTF-8
  endian: le
doc: |
  Stat multipliers that apply on top of the global difficulty multiplier,
  in percent. Only used on Hard and Nightmare mode.

  Present in t_status.tbl.
seq:
  - id: difficulty
    type: difficulty
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
