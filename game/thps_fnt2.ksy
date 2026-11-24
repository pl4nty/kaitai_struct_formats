# Imported from https://github.com/DCxDemo/LegacyTHPS/blob/075ab69a9b2e7fcd042402cc2cccaf84ccb13e87/formats/thps_fnt2.ksy
# Licence and copyright: see _community/README.md
meta:
  id: thps_fnt2
  title: Tony Hawk's Underground 2 bitmap font (FNT2)
  application: Tony Hawk's Underground 2
  file-extension: fnt.xbx
  license: GPL-3.0-only
  endian: le

doc: |
  Bitmap font found in several Tony Hawk's Pro Skater games and derivatives, given
  a FNT2 label.

doc-ref: https://github.com/DCxDemo/LegacyTHPS/blob/master/formats/thps3_fnt2.ksy

seq:
  - id: file_size # this is actually calculated using FNT1 sizes, hence doesn't match actual FNT2 size
    type: u4
  - id: unk1
    type: u4
  - id: num_glyphs
    type: u4
  - id: height
    type: u4
  - id: baseline
    type: u4

  - id: glyphs
    type: glyph
    repeat: expr
    repeat-expr: num_glyphs

  - id: remain_size
    type: u4
  - id: bmp
    type: bitmap
  - id: num_layouts
    type: u4
  - id: layouts
    type: rectangle
    repeat: expr
    repeat-expr: num_layouts

types:
  bitmap:
    seq:
      - id: size
        type: vector2s
      - id: bpp
        type: u2
      - id: reserved # assume it's never used
        size: 6
      - id: data
        size: size.x * size.y
      - id: palette
        size: 256 * 4

  glyph:
    seq:
      - id: vshift
        type: u2
      - id: symbol_code
        size: 2
        type: str
        encoding: UTF-16LE
      - id: unk
        type: u2

  rectangle:
    seq:
      - id: position
        type: vector2s
      - id: size
        type: vector2s

  vector2s:
    seq:
      - id: x
        type: u2
      - id: y
        type: u2
