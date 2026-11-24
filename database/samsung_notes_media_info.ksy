# Imported from https://github.com/Downhillghost/Dietrich/blob/bb9c9202a8ab2bf96347e6cd0b16eaa354b80483/schema/samsung_notes/samsung_media_info.ksy
meta:
  id: samsung_notes_media_info
  title: Samsung Notes media info
  license: MIT
  endian: le
seq:
  - id: format_version
    type: u4
  - id: num_entries
    type: u2
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: num_entries
  - id: footer_marker
    size-eos: true
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
      - id: entry_size
        type: u4
      - id: body
        size: entry_size
        type: entry_body
  entry_body:
    seq:
      - id: bind_id
        type: u4
      - id: filename
        type: utf16_string_u16
      - id: file_hash_raw
        size: 64
      - id: ref_count
        type: u2
      - id: modified_time
        type: u8
      - id: is_file_attached
        type: u1
      - id: extra_bytes
        size-eos: true
