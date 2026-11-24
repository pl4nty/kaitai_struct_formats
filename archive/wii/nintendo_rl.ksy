# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/nintendo-rl.ksy
meta:
  id: nintendo_rl
  title: Nintendo run-length compression (RL, magic 0x30)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Nintendo's run-length compression wrapper, as read by
  DecodeNintendoRL() in lib-nintendo-rl.c. Shares the same 4-byte
  header shape as the LZ10/LZ11 family (1-byte magic + 24-bit
  little-endian decompressed size) but uses a simple run-length token
  stream instead of LZSS back-references: each token's high bit
  selects a compressed run (next byte repeated len times, len =
  (control & 0x7f) + 3) or a literal run (len = (control & 0x7f) + 1
  raw bytes follow).
seq:
  - id: magic
    contents: [0x30]
  - id: size_lo24
    type: u1
    repeat: expr
    repeat-expr: 3
    doc: The 3 low-to-high bytes of the 24-bit decompressed size.
  - id: token_stream
    size-eos: true
    doc: |
      Sequence of control bytes; bit 7 set = compressed run (1 byte
      repeated (control & 0x7f) + 3 times), clear = literal run
      ((control & 0x7f) + 1 raw bytes follow the control byte).
instances:
  decoded_size:
    value: 'size_lo24[0].as<u4> | (size_lo24[1].as<u4> << 8) | (size_lo24[2].as<u4> << 16)'
