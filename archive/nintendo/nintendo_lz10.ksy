# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/lz10.ksy
meta:
  id: nintendo_lz10
  title: Nintendo LZ10/LZ11 compression wrapper
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Standard Nintendo LZSS compression used across DS/Wii/3DS titles. LZ11
  extends LZ10's back-reference encoding with longer match lengths/distances
  but shares this same header shape.
seq:
  - id: magic
    type: u1
    enum: variant
    valid:
      any-of:
        - variant::lz10
        - variant::lz11
  - id: size_lo24
    type: u1
    repeat: expr
    repeat-expr: 3
    doc: The 3 low-to-high bytes of the 24-bit decompressed size.
  - id: token_stream
    size-eos: true
    doc: |
      Flag-group/back-reference LZSS stream (groups of 8 tokens
      prefixed by a flag byte; literal bytes copied verbatim, matches
      encoded as 2 or 3 bytes depending on LZ10 vs LZ11 match length).
instances:
  decoded_size:
    value: 'size_lo24[0].as<u4> | (size_lo24[1].as<u4> << 8) | (size_lo24[2].as<u4> << 16)'
enums:
  variant:
    0x10: lz10
    0x11: lz11
