# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/stbltext.ksy
meta:
  id: harvest_moon_stbl
  title: Harvest Moon Animal Parade STBL string table
  file-extension: stb
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: magic
    contents: STBL
  - id: version
    type: u4
    doc: 0x01000001.
  - id: entry_count
    type: u4
  - id: string_width
    type: u4
    doc: Bytes per string, 0x40.
  - id: table_offset
    type: u4
    doc: 0x18.
  - id: data_offset
    type: u4
instances:
  entries:
    pos: table_offset
    type: entry
    repeat: expr
    repeat-expr: entry_count
types:
  entry:
    seq:
      - id: id
        type: u4
      - id: zero
        type: u4
      - id: string_count
        type: u4
      - id: first_string_offset
        type: u4
    instances:
      strings:
        io: _root._io
        pos: first_string_offset
        type: str_fixed
        repeat: expr
        repeat-expr: string_count
  str_fixed:
    seq:
      - id: text
        size: _root.string_width
        type: str
        encoding: UTF-16BE
