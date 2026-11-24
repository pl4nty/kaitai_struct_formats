# Imported from https://github.com/vfig/SaturnQuakePC/blob/a53c4034a948489d5883252c4f9982af81259356/tools/kaitaistruct/dat_skank.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dat_skank
  file-extension: dat
  license: GPL-2.0-only
  endian: be
  bit-endian: be

seq:
  - id: header
    type: header_t
  - id: bitmaps
    type: bitmap_t
    repeat: expr
    repeat-expr: 8

types:
  header_t:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
      - id: padding
        size: 6400

  bitmap_t:
    seq:
      - id: bitmap
        type: bitmap_entry_t
        repeat: expr
        repeat-expr: _root.header.width * _root.header.height

  bitmap_entry_t:
    seq:
      - id: a
        type: b1
      - id: b
        type: b5
      - id: g
        type: b5
      - id: r
        type: b5
