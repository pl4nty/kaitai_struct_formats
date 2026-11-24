# Imported from https://github.com/desuex/torus-tools/blob/b2bdf033a06e70c7342ecce8f54172726b7b6568/TorusTool/Formats/Schemas/string_table.ksy
meta:
  id: torus_string_table
  title: TSE String Table
  license: LicenseRef-All-Rights-Reserved
  endian: le

doc: |
  Body layout of a TSEStringTableMain record. Header is 28 bytes followed by
  two parallel arrays (one of string offsets, one of hash codes) at positions
  named in the header. The actual null-terminated string bytes live elsewhere
  in the buffer and are read by the C# wrapper using the offsets array — this
  schema covers the deterministic structural part only.

seq:
  - id: v0
    type: u4
  - id: v1
    type: u4
  - id: num_entries
    type: u4
  - id: ofs_offsets
    type: u4
    doc: Byte offset (within this record body) of the offsets array.
  - id: ofs_hashes
    type: u4
    doc: Byte offset of the hashes array.
  - id: v5
    type: u4
  - id: v6
    type: u4

instances:
  offsets:
    pos: ofs_offsets
    type: u4
    repeat: expr
    repeat-expr: num_entries
  hashes:
    pos: ofs_hashes
    type: u4
    repeat: expr
    repeat-expr: num_entries
