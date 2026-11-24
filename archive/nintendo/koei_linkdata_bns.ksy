# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/bns.ksy
meta:
  id: koei_linkdata_bns
  title: Koei Tecmo LINKDATA .BNS archive (Samurai Warriors 3, Wii)
  file-extension: bns
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  A flat, block-aligned data archive Koei Tecmo ships as `LINKDATA*.BNS` on
  Samurai Warriors 3 (Wii).
seq:
  - id: unused
    size: 4
    doc: Not part of the validated header fields.
  - id: num_entries
    type: u4
  - id: block_size
    type: u4
    doc: Alignment granularity for entry offsets.
  - id: reserved
    type: u4
    doc: Must be zero.
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: num_entries
types:
  entry:
    seq:
      - id: block_index
        type: u4
        doc: Entry offset in the file is `block_index * _root.block_size`.
      - id: len_entry
        type: u4
    instances:
      body:
        pos: block_index * _root.block_size
        size: len_entry
        if: len_entry > 0
