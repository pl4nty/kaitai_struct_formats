# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/bnr.ksy
meta:
  id: gamecube_bnr
  title: GameCube/Wii BNR disc banner
  file-extension: bnr
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  The disc-launcher banner every GameCube and Wii title carries: a 96x32
  RGB5A3 icon plus, for BNR2, up to six language blocks of Shift-JIS
  title/subtitle/description text. `BNR1` is the GameCube (single-language)
  variant; `BNR2` is the Wii (six-language) variant that follows it under
  the same 0x20-byte header and pixel layout, just with a bigger comment
  table after the icon.
seq:
  - id: magic
    size: 4
    type: str
    encoding: ASCII
    valid:
      any-of: ['"BNR1"', '"BNR2"']
    doc: '`BNR1` (GameCube, one language) or `BNR2` (Wii, six languages).'
  - id: reserved
    size: 0x1c
    doc: |
      Padding between the magic and the icon pixels; the total header is
      0x20 bytes.
  - id: icon
    type: icon_pixel
    repeat: expr
    repeat-expr: 96 * 32
    doc: |
      96x32 RGB5A3 texels, stored 4x4-pixel-tiled (GX `CMPR`-style block
      order): tiles run left-to-right/top-to-bottom, and within each tile
      pixels also run left-to-right/top-to-bottom.
  - id: comments
    size-eos: true
    doc: |
      One 0x140-byte Shift-JIS comment block (game name / developer /
      full title / full developer / description, NUL-padded) for BNR1, or
      six such blocks (one per Wii system language) for BNR2. Not decoded
      here.
types:
  icon_pixel:
    seq:
      - id: raw
        type: u2
    instances:
      is_opaque:
        value: (raw & 0x8000) != 0
        doc: Bit 15 set selects RGB5 with full alpha; clear selects IA4-style RGBA4.
      r:
        value: 'is_opaque ? (raw >> 10 & 0x1f) * 255 / 31 : (raw >> 8 & 0xf) * 17'
      g:
        value: 'is_opaque ? (raw >> 5 & 0x1f) * 255 / 31 : (raw >> 4 & 0xf) * 17'
      b:
        value: 'is_opaque ? (raw & 0x1f) * 255 / 31 : (raw & 0xf) * 17'
      a:
        value: 'is_opaque ? 255 : (raw >> 12 & 7) * 255 / 7'
