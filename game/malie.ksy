# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/malie.ksy
# Licence and copyright: see _community/README.md
meta:
  id: malie
  title: malie archive file
  file-extension: dat
  license: MIT
  endian: le

seq:
  - id: header
    size: 16

types:
  header:
    seq:
      - id: magic
        contents: "LIBP"
      - id: file_entries_count
        type: u4
      - id: unk2
        type: u4
      - id: unk3
        type: u4
  file_entry:
    seq:
      - id: name
        size: 22
        type: str
        terminator: 0
        encoding: ASCII
      - id: type
        type: u2
      - id: file_offset
        type: u4
      - id: file_size
        type: u4
