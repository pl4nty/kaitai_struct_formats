# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/lang_str.ksy
meta:
  id: lang_str
  title: Localised string table (.str, Humongous / Atari Wii ports)
  file-extension: str
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Localised string table (Freddi Fish: Kelp Seed Mystery `lang_en.str` and other
  Humongous / Atari Wii ports). UTF-16BE strings are stored back to back after
  the table (the first offset is `12 + 8 * count`).
seq:
  - id: tag
    type: u4
    doc: Varies.
  - id: version
    type: u4
    doc: Bytes 01 00 00 00.
  - id: count
    type: u4
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: count
types:
  entry:
    seq:
      - id: offset
        type: u4
      - id: len_bytes
        type: u4
    instances:
      text:
        io: _root._io
        pos: offset
        size: len_bytes
        type: str
        encoding: UTF-16BE
