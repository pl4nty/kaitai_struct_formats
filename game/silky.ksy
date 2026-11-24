# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/silky.ksy
meta:
  id: silky
  title: silky archive file
  file-extension: arc
  license: MIT
  endian: le

seq:
  - id: entries_size
    type: u4
  - id: entries
    size: entries_size
    type: file_entries

instances:
  file_data_offset:
    value: entries_size + 4

types:
  file_entries:
    seq:
      - id: entries
        type: file_entry
        repeat: eos
  file_entry:
    seq:
      - id: name_length
        type: u1
      - id: name
        size: name_length
      - id: file_size
        type: u4
      - id: uncompressed_file_size
        type: u4
      - id: file_offset
        type: u4
