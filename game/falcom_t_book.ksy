# Imported from https://github.com/akatatsu27/FalcomToolsCollection/blob/e847d8a3b69949a6d036099ac1cd165a5657272b/DT22/T_BOOK.ksy
meta:
  id: falcom_t_book
  title: Trails in the Sky book table (T_BOOK)
  license: GPL-2.0-only
  endian: le
seq:
  - id: hex_14
    contents: [0x14]
  - id: unknown
    type: u2
  - id: rest_of_header
    type: u4
    repeat: expr
    repeat-expr: 4
  - id: books
    type: book
    repeat: eos
types:
  book:
    seq:
      - id: title
        type: strz
        encoding: Shift_JIS
      - id: pages # 10 * 0x8140 (_) is used as a page separator
        type: strz
        encoding: Shift_JIS
