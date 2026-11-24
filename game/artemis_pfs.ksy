# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/pfs.ksy
meta:
  id: artemis_pfs
  title: pfs file
  file-extension: pfs
  license: MIT
  endian: le

seq:
  - id: magic
    contents: "pf8"
  - id: header
    type: header
  - id: entries
    type: file_entry
    repeat: expr
    repeat-expr: header.file_entries_count

instances:
  raw_archive_data:
    pos: 7
    size: header.archive_data_size

types:
  header:
    seq:
      - id: archive_data_size
        type: u4
      - id: file_entries_count
        type: u4
  file_entry:
    seq:
      - id: file_name_size
        type: u4
      - id: file_name
        size: file_name_size
      - id: unk
        type: u4
      - id: file_offset
        type: u4
      - id: file_size
        type: u4
