# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/dctdict.ksy
meta:
  id: dctdict
  title: Chicken Little Ace in Action string dictionary (.dct)
  file-extension: dct
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Text is NUL-terminated UTF-8 at (address of the offset field + offset + 1), i.e.
  0x19 + 8 * n + offset.
seq:
  - id: magic
    contents: DICT
  - id: x1000
    type: u4
  - id: checksum
    type: u4
  - id: seven
    type: u4
  - id: count
    type: u4
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: count
types:
  entry:
    seq:
      - id: hash
        type: u4
      - id: offset
        type: u4
