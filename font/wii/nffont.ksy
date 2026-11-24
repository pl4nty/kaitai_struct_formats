# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/nffont.ksy
meta:
  id: nffont
  title: Gamebryo bitmap font (.nff, Monster Mayhem)
  file-extension: nff
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Header with the point size, glyph code list (u16 per glyph, first is the
  replacement glyph) and cell table ending in {u32 width, u32 height, u32 32};
  the atlas follows as width * height RGBA8 pixels.
seq:
  - id: magic
    contents: ["NFF", 0]
  - id: version
    type: u4
    doc: 1-3.
  - id: name_length
    type: u4
  - id: name
    size: name_length
    type: strz
    encoding: ASCII
  - id: rest
    size-eos: true
