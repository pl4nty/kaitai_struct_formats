# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/willplus_arc.ksy
# Licence and copyright: see _community/README.md
meta:
  id: willplus_arc
  title: willplus arc archive file
  file-extension: arc
  license: MIT
  endian: le

seq:
  - id: entries_count
    type: u4
  - id: entries_size
    type: u4
  - id: entries
    size: entries_size
    type: file_entries

instances:
  file_data_offset:
    value: entries_size + 8

types:
  file_entries:
    seq:
      - id: entries
        type: file_entry
        repeat: eos
  file_entry:
    seq:
      - id: file_size
        type: u4
      - id: file_offset
        type: u4
      # - id: file_name
      #   type: strz
      #   encoding: UTF-16LE
