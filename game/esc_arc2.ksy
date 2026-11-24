# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/esc_arc2.ksy
# Licence and copyright: see _community/README.md
meta:
  id: esc_arc2
  title: esc_arc2 file
  file-extension: bin
  license: MIT
  endian: le

seq:
  - id: magic
    contents: "ESC-ARC2"
  - id: unk1
    type: u4
  - id: file_count
    type: u4
  - id: unk2
    type: u4

instances:
  key:
    value: 0x65AC9365
  file_entry_size:
    value: 12

types:
  file_entry:
    seq:
      - id: file_name_table_offset
        type: u4
      - id: file_offset
        type: u4
      - id: file_size
        type: u4
