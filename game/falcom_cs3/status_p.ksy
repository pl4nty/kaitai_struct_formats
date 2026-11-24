# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/status_p.ksy
# Licence and copyright: see _community/README.md
meta:
  id: status_p
  title: Trails of Cold Steel III player status entry
  license: MIT
  imports:
    - character
    - status
  encoding: UTF-8
  endian: le
doc: |
  Player status.
  Includes stat bases and growths; elemental, status, and unbalance
  efficacies; sepith and item drops; and more.

  Extremely similar to the monster status table (status).

  Present in t_status.tbl
seq:
  - id: character_id
    type: character
  - id: status
    type: status
