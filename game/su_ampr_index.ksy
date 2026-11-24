# Imported from https://github.com/MaouAnimus/YoteiPort/blob/7994dfaa023691469ac0f6b03a96afe55896f47c/tools/ampr_index.ksy
# Licence and copyright: see _community/README.md
meta:
  id: su_ampr_index
  title: Sucker Punch Ghost of Yotei AMPR Index (ampr_emu.index)
  file-extension: index
  license: MIT
  endian: le

doc: |
  Index file (`ampr_emu.index`) used by Ghost of Yotei (PS5) for fast
  asset lookup and APR/AMPR (Asynchronous Memory Page Reader) streaming.
  Maps 64-bit asset path hashes to file sizes and mount-point paths.

seq:
  - id: magic
    contents: "AMPRIDX3"
  - id: version
    type: u4
  - id: entry_size
    type: u4
  - id: num_entries
    type: u8
  - id: string_table_size
    type: u8
  - id: reserved_meta_offset
    type: u8
  - id: pad_header
    size: 24
  - id: entries
    type: file_entry
    repeat: expr
    repeat-expr: num_entries
  - id: string_table
    size: string_table_size

types:
  file_entry:
    seq:
      - id: path_hash
        type: u8
      - id: name_offset
        type: u4
      - id: name_len
        type: u4
      - id: file_size
        type: u8
    instances:
      path_and_mount:
        io: _root._io
        pos: 64 + (_root.num_entries * 24) + name_offset
        size: name_len
        type: str
        encoding: UTF-8
