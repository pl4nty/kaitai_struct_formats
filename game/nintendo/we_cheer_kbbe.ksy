# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/kbbe.ksy
meta:
  id: we_cheer_kbbe
  title: We Cheer 2 on-screen keyboard layout (keydata.bin)
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  We Cheer 2 (Wii) on-screen keyboard layouts (`subscreen/keydata.bin`). A table
  runs up to the next table's first cell (the last one to the end of the file)
  and ends with a `{0xFF, 0xFF, 0, 0}` terminator.
seq:
  - id: magic
    contents: KBBE
  - id: num_tables
    type: u4
  - id: tables
    type: table
    repeat: expr
    repeat-expr: num_tables
types:
  table:
    seq:
      - id: zero
        type: u4
      - id: first_cell_index
        type: u4
  cell:
    seq:
      - id: column
        type: u1
      - id: row
        type: u1
      - id: code_unit
        type: u2
        doc: UTF-16 code unit.
