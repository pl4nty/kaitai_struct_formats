# Imported from https://github.com/Downhillghost/Dietrich/blob/bb9c9202a8ab2bf96347e6cd0b16eaa354b80483/schema/samsung_notes/samsung_page_id_info.ksy
meta:
  id: samsung_notes_page_id_info
  title: Samsung Notes page ID info
  license: MIT
  endian: le
seq:
  - id: file_hash
    size: 32
  - id: num_entries
    type: u2
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: num_entries
types:
  utf16_string_u16:
    seq:
      - id: len
        type: u2
      - id: value
        size: len * 2
        type: str
        encoding: UTF-16LE
        if: len != 65535
  entry:
    seq:
      - id: page_id
        type: utf16_string_u16
      - id: page_hash
        size: 32
