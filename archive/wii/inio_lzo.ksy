# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/inio_lzo.ksy
meta:
  id: inio_lzo
  title: iNiS LZO1X container (1OZL)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  iNiS's LZO1X container used by the rhythm games Osu! Tatakae! Ouendan,
  Moero! Nekketsu Rhythm Damashii (Ouendan 2) and Elite Beat Agents. It wraps
  graphics, movies, palettes and animations (the files carry extensions such
  as `.omv_`, `.oml_`, `.ntfp_`, `.seq_`, `.NCGR_`, `.NSCR_`, `.NCLR_`,
  `.NCER_`, `.NANR_`). 15,702 Ouendan 2 streams decompress with exact size
  matches. The payload is plain LZO1X and unpacks to standard Nitro formats
  (NCGR, NSCR, NCLR, NCER, NANR) or proprietary iNiS structures.
seq:
  - id: magic
    contents: '1OZL'
    doc: ASCII for `LZO1` read backwards (`0x314F5A4C`).
  - id: uncompressed_size
    type: u4
  - id: compressed_size
    type: u4
  - id: lzo1x_stream
    size: compressed_size
    doc: Raw LZO1X-compressed payload.
