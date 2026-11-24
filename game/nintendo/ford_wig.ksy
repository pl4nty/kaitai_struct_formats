# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/ford_wig.ksy
meta:
  id: ford_wig
  title: Ford Racing Off Road graphics.wig (inflated)
  file-extension: wig
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Inflated body of Ford Racing - Off Road `graphics.wig`. On disk the file is
  `le32 inflated size` and a zlib stream; this describes what the zlib stream
  inflates to. Images are at `0x10 + 16 * count + offset`, each with its own
  0x40-byte header (`le32 0, 1, width, height, ...`).
seq:
  - id: count
    type: u4
  - id: zeros
    size: 12
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: count
types:
  entry:
    seq:
      - id: offset
        type: u4
      - id: name
        size: 12
        type: strz
        encoding: ASCII
