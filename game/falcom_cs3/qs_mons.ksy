# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/qs_mons.ksy
# Licence and copyright: see _community/README.md
meta:
  id: qs_mons # QSMons
  title: Trails of Cold Steel III monster notebook entry
  license: MIT
  encoding: UTF-8
  endian: le
doc: |
  Monster notebook entries.
  Stats are taken from t_status.tbl.

  Present in t_notemons.tbl.
seq:
  - id: enemy_script
    type: strz
  - id: unknown_string
    type: strz
  - id: section_id
    type: s2
  - id: unknown_short
    type: u2
    doc: |
      In the original files, this takes values from 0 to 299 (inclusive) and is unique
      for every monster, suggesting it may be used as an ID or sort order.
      However, swapping or duplicating values doesn't have any known effect.
  - id: is_extra
    type: u1
    doc: 1 for every monster in the "EXTRA" section, 0 for all others.
  - id: unknown_byte
    type: u1
    doc: In the original files, this byte is always 0.
