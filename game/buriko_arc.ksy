# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/buriko_arc.ksy
# Licence and copyright: see _community/README.md
meta:
  id: buriko_arc
  title: buriko arc file
  file-extension: arc
  license: MIT
  endian: le

seq:
  - id: magic
    contents: "BURIKO ARC"
  - id: version
    size: 2
    type: str
    encoding: ASCII
  - id: entry_count
    type: u4
  - id: file_entries
    type: file_entry
    repeat: expr
    repeat-expr: entry_count

instances:
  file_contents_offset:
    value: 0x10 + entry_count * 0x80

types:
  file_entry:
    seq:
      - id: name
        size: 0x60
      - id: file_offset
        type: u4
      - id: file_size
        type: u4
      - id: unknown
        size: 0x18
