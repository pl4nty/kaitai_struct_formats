# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/lzh8.ksy
meta:
  id: lzh8
  title: Nintendo LZH8 (0x40) compression wrapper
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Nintendo's Huffman+LZ "LZH8" compression, ported from lib-lzh8.c (a
  buffer-based port of hcs's public-domain reference). The core header
  is a single little-endian u32 whose low byte is the 0x40 magic and
  whose upper 24 bits hold the decompressed size. Some titles (e.g.
  WarioWare: Snapped!) prefix that with one extra little-endian u32
  giving an outer size before the real 0x40 header; this definition
  models the common case with no such prefix.
seq:
  - id: header
    type: u4
    valid:
      expr: header & 0xff == 0x40
    doc: 'Low byte: magic 0x40. Upper 24 bits: decompressed size.'
  - id: compressed_stream
    size-eos: true
instances:
  decompressed_size:
    value: header >> 8
