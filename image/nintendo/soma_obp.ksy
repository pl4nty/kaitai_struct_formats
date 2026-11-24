# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/soma_obp.ksy
meta:
  id: soma_obp
  title: Monolith Soft OBP1 sprite/object graphic (Soma Bringer .obp / .ntp)
  file-extension: obp
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  `OBP1` sprite / object graphic of Soma Bringer (204 files validated): a
  16-byte header, an RGB555 palette and 4 bpp or 8 bpp tile data. Width and
  height are each 1..2048. `payload_size` is whatever follows the palette.
seq:
  - id: magic
    contents: 'OBP1'
  - id: flags0
    type: u2
  - id: flags1
    type: u2
  - id: width
    type: u2
  - id: height
    type: u2
  - id: stride
    type: u2
  - id: palette_bytes
    type: u2
    doc: Two bytes per RGB555 colour.
  - id: palette
    type: u2
    repeat: expr
    repeat-expr: palette_bytes / 2
    doc: RGB555 (`r = c & 0x1f`, `g = (c >> 5) & 0x1f`, `b = (c >> 10) & 0x1f`).
  - id: tile_data
    size-eos: true
