# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/exibnk.ksy
meta:
  id: exibnk
  title: Exient sound bank (.bnk)
  file-extension: bnk
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Exient sound bank (Need for Speed: Hot Pursuit, Wii). The entry list ends in
  0xFFFFFFFF words; every member is a complete `WIIADPCM` stream.
seq:
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
      - id: len_data
        type: u4
      - id: zero
        type: u4
    instances:
      data:
        io: _root._io
        pos: offset
        size: len_data
