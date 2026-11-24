# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/sting_pah.ksy
meta:
  id: sting_pah
  title: Sting GAME.PAH index (Dokapon Kingdom)
  file-extension: pah
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Sting `GAME.PAH` index for the `GAME.PAC` data file (Dokapon Kingdom, Wii).
  Each 16-byte entry's `offset` / `size` address `GAME.PAC`; names are
  NUL-terminated strings stored inside this index. The data file is hundreds of
  megabytes, so only the index is modelled here.
seq:
  - id: num_entries
    type: u4
  - id: entry_table_offset
    type: u4
    doc: 0x70.
instances:
  entries:
    pos: entry_table_offset
    type: entry
    repeat: expr
    repeat-expr: num_entries
types:
  entry:
    seq:
      - id: offset
        type: u4
        doc: Into GAME.PAC.
      - id: len_data
        type: u4
      - id: zero
        type: u4
      - id: name_offset
        type: u4
        doc: Into this index.
    instances:
      name:
        io: _root._io
        pos: name_offset
        type: strz
        encoding: ASCII
