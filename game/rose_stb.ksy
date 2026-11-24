# Imported from https://github.com/SevenHearts/portship.js/blob/124d26389d1f7c0bd621894f1d44a9c75c8c9c2e/src/format/STB.ksy
meta:
  id: rose_stb
  title: ROSE Online data table (.stb)
  file-extension: stb
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: format
    size: 4
    type: str
    encoding: ASCII
  - id: data_offset
    type: u4
  - id: row_count
    type: u4
  - id: column_count
    type: u4
  - id: row_height
    type: u4
  - id: root_column_width
    type: u2
  - id: column_widths
    type: u2
    repeat: expr
    repeat-expr: column_count
  - id: root_column_title
    type: sstr
  - id: column_titles
    type: sstr
    repeat: expr
    repeat-expr: column_count
  - id: root_data
    type: sstr
  - id: first_cell_data
    type: sstr
    repeat: expr
    repeat-expr: row_count - 1
instances:
  data:
    pos: data_offset
    type: data_table
types:
  sstr:
    seq:
      - id: len
        type: u2
      - id: data
        size: len
        type: str
        encoding: ASCII
  data_table:
    seq:
      - id: rows
        type: row
        repeat: expr
        repeat-expr: _root.row_count - 1
    types:
      row:
        seq:
          - id: cells
            type: sstr
            repeat: expr
            repeat-expr: _root.column_count - 1
