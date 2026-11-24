# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/unitedata.ksy
meta:
  id: unitedata
  title: UnitedData DATA.UNH header (Champion Jockey)
  file-extension: unh
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Entries index into DATA.UNB; zlib when packed_size < unpacked_size,
  otherwise stored.
seq:
  - id: magic
    contents: UNTH
  - id: count
    type: u4
  - id: pad
    size: 8
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: count
types:
  entry:
    seq:
      - id: offset_high
        type: u4
      - id: offset_low
        type: u4
      - id: hash
        type: u4
      - id: zero
        type: u4
      - id: unpacked_size
        type: u4
      - id: packed_size
        type: u4
    instances:
      offset:
        value: (offset_high.as<u8> << 32) | offset_low
