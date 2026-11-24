# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/cs3/tbl/qs_chapter.ksy
meta:
  id: qs_chapter # QSChapter
  title: Trails of Cold Steel III notebook chapter entry
  license: MIT
  encoding: UTF-8
  endian: le
doc: |
  Notebook chapters.

  Present in t_navi.tbl, t_notebook.tbl, t_notecard.tbl, t_notechar.tbl,
  t_notehelp.tbl, t_notemons.tbl, t_notesynp.tbl, t_quest.tbl.
seq:
  - id: section_id
    type: s2
  - id: section_name
    type: strz
  - id: unknown
    type: u2
