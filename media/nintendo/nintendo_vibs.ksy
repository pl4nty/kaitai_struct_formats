# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/switch/vibs.ksy
meta:
  id: nintendo_vibs
  title: Nintendo Switch Joy-Con Vibration Archive (.vibs)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: Nintendo Switch Joy-Con vibration archive.
seq:
  - id: version
    type: u4
  - id: num_entries
    type: u4
  - id: entries
    type: entry_t
    repeat: expr
    repeat-expr: num_entries
types:
  entry_t:
    seq:
      - id: name
        size: 24
        type: str
        terminator: 0
        encoding: ASCII
      - id: unknown_18
        size: 32 - 24
      - id: data_length
        type: u4
      - id: unknown_24
        size: 40 - 36
      - id: data_offset
        type: u4
    instances:
      body:
        io: _root._io
        pos: data_offset
        size: data_length
