# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/mvdk.ksy
meta:
  id: mvdk
  title: Monster Games "MvDK" custom deflate/LZ/RLE wrapper
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Mario vs. Donkey Kong family compression wrapper, as read by
  CxDecompressMvDK()/CxIsCompressedMvDK() in lib-nintendo-rl.c
  (ported from Garhoogin/NitroPaint). A single 32-bit little-endian
  header word packs both the compression method (low 2 bits) and the
  decompressed size (remaining 30 bits, header >> 2); the payload
  format then depends on that method:
    0 (dummy)   -- raw bytes, no compression.
    1 (lz)      -- classic Nintendo LZ10-shaped back-reference stream.
    2 (deflate) -- a custom bit-oriented Huffman+LZ scheme, split into
                   chunks each carrying their own two canonical
                   Huffman trees (literals/lengths, then distances).
    3 (rle)     -- classic Nintendo RL-shaped run-length stream.
seq:
  - id: header
    type: u4
  - id: payload
    size-eos: true
instances:
  method:
    value: header & 3
    enum: method
  decoded_size:
    value: header >> 2
enums:
  method:
    0: dummy
    1: lz
    2: deflate
    3: rle
