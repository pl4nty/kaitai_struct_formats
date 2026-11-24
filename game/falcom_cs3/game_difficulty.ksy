# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/game_difficulty.ksy
# Licence and copyright: see _community/README.md
meta:
  id: game_difficulty
  title: Trails of Cold Steel III game difficulty entry
  license: MIT
  imports:
    - difficulty
  encoding: UTF-8
  endian: le
doc: |
  Difficulty stat multipliers.

  Present in t_status.tbl.
seq:
  - id: difficulty
    type: difficulty
  - id: multiplier
    type: s2
