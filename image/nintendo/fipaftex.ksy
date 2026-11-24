# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/fipaftex.ksy
meta:
  id: fipaftex
  title: Marvelous FIPAFTEX texture set
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Marvelous `FIPAFTEX` texture set (Harvest Moon: Animal Parade; the `TEX`
  members of `pBin` containers, see `marvelous_pbin`). A 0x40-byte file header
  is followed by the textures back to back, each a 0x40-byte header and the GX
  pixel data (base level, then the mips). The pixel data size is derived from
  the format and size, so only the headers are modelled.
seq:
  - id: magic
    contents: FIPAFTEX
  - id: version
    type: u4
  - id: count
    type: u4
  - id: reserved
    size: 0x30
types:
  texture_header:
    seq:
      - id: reserved0
        size: 0x14
      - id: width
        type: u2
      - id: height
        type: u2
      - id: gx_format
        type: u4
      - id: reserved1
        size: 8
      - id: num_mips
        type: u4
      - id: reserved2
        size: 0x18
