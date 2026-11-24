# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/zsnd.ksy
meta:
  id: zaxis_zsnd
  title: Z-Axis ZSND sound bank (GCUB variant)
  file-extension: zss
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Marvel Ultimate Alliance 2. Table 2 @0x1c holds 0x18-byte entries (u16
  layers @2: 0/1 mono, 2 stereo, 0x22 four channels; u32 rate @4); table 3
  @0x28 holds 0x0c-byte {stream offset, stream size, "DSP "}. A stream has one
  0x60-byte DSP header per channel, then data interleaved in 0x8000 blocks.
seq:
  - id: magic
    contents: ZSND
  - id: variant
    contents: GCUB
  - id: size
    type: u4
  - id: header_size
    type: u4
  - id: tables
    type: table_ref
    repeat: expr
    repeat-expr: 3
types:
  table_ref:
    seq:
      - id: entries
        type: u4
      - id: head_offset
        type: u4
      - id: body_offset
        type: u4
