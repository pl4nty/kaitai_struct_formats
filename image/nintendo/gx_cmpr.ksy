# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/media/cmpr.ksy
meta:
  id: gx_cmpr
  title: Nintendo GameCube/Wii CMPR compressed texture block
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  `CMPR` is not a standalone file format with its own header. There is no
  magic number or container to model -- only the fixed layout of the
  compressed texel data itself, which is why this .ksy models a single "CMPR
  image" as a 2D grid of 8x8-pixel macro-blocks rather than a file.

  It is Nintendo's own tiling of a DXT1-style S3TC codec: each 8x8 pixel
  macro-block is split into four 4x4 sub-blocks (top-left, top-right,
  bottom-left, bottom-right), and each 4x4 sub-block is one ordinary DXT1
  block: two RGB565 endpoint colors (`color0`, `color1`) followed by sixteen
  2-bit indices (packed as four bytes, four indices per byte,
  most-significant pair first) selecting between `color0`, `color1`, and two
  derived colors.

  Macro-blocks are stored row-major, left to right then top to bottom,
  covering an image whose width/height are rounded up to a multiple of 8.
seq:
  - id: macro_blocks
    type: macro_block
    repeat: eos
types:
  macro_block:
    doc: |
      One 8x8-pixel block, stored as four 4x4 DXT1-style sub-blocks in TL/TR/BL/BR
      order.
    seq:
      - id: sub_blocks
        type: dxt1_sub_block
        repeat: expr
        repeat-expr: 4
  dxt1_sub_block:
    doc: One 4x4-pixel DXT1-style block.
    seq:
      - id: color0
        type: u2
        doc: RGB565 endpoint color, packed 5 bits red / 6 bits green / 5 bits blue.
      - id: color1
        type: u2
        doc: RGB565 endpoint color, packed 5 bits red / 6 bits green / 5 bits blue.
      - id: indices
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: |
          Sixteen 2-bit palette indices, four per byte (rows of the 4x4
          block), most-significant 2 bits = leftmost pixel of the row.
