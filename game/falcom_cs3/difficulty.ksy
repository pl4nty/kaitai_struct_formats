# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/components/cs3/difficulty.ksy
# Licence and copyright: see _community/README.md
meta:
  id: difficulty
  title: Trails of Cold Steel III difficulty ID
  license: MIT
  endian: le
seq:
  - id: difficulty_id
    type: u2
    enum: difficulties
enums:
  difficulties:
    0: normal
    1: very_easy
    2: easy
    3: hard
    4: nightmare
