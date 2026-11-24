# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/gxp.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gxp
  title: gxp file
  file-extension: gxp
  license: MIT
  endian: le

seq:
  - id: header
    type: header
  - id: file_entries
    size: header.file_entries_size

instances:
  raw_file_data:
    pos: header.raw_file_data_offset
    size: header.raw_file_data_size

types:
  header:
    seq:
      - id: magic
        contents: "GXP\x00"
      - id: unk_04
        type: u4
      - id: unk_08
        type: u4
      - id: unk_0c
        type: u4
      - id: unk_10
        type: u4
      - id: unk_14
        type: u4
      - id: file_entries_count
        type: u4
      - id: file_entries_size
        type: u4
      - id: raw_file_data_size
        type: u4
      - id: unk_24
        type: u4
      - id: raw_file_data_offset
        type: u4
      - id: unk_2c
        type: u4

  file_entry:
    seq:
      - id: entry_size
        type: u4
      - id: file_size
        type: u4
      - id: unk_08
        type: u4
      - id: file_name_utf16_len
        type: u4
      - id: unk_10
        type: u4
      - id: unk_14
        type: u4
      - id: file_offset
        type: u4
      - id: unk_1c
        type: u4
      - id: file_name
        size: entry_size - 0x20
        type: str
        encoding: UTF-16LE
