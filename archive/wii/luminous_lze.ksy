# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/luminous_lze.ksy
meta:
  id: luminous_lze
  title: Luminous Arc 2 LZE compression
  file-extension: lze
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Luminous Arc 2 / 3 `Le` compression (token layout documented by CUE's
  `lze.c`, 2011). Six-byte header: two magic bytes `Le` and the little-endian
  decoded size. The stream is a series of flag bytes, each carrying four
  two-bit commands, consumed from the low bits:

  * mode 0 -- long-distance match: `u2` value, `count = (value >> 12) + 3`,
    `back = (value & 0xfff) + 5`;
  * mode 1 -- short-distance match: `u1` value, `count = (value >> 2) + 2`,
    `back = (value & 3) + 1`;
  * mode 2 -- one literal byte;
  * mode 3 -- three literal bytes (the final triple may end at the declared
    size).

  Matches may overlap. A reference before the output start or past the
  declared length is invalid. Trailing alignment bytes are permitted. All 1,275
  streams (17,197,224 decoded bytes) of the Luminous Arc 2 (USA) sample match
  CUE's reference decoder byte for byte; the corpus holds `.LZE`, `.imb`,
  `.scb` and `.bin` files. Decoded size may not exceed 8 MiB for backgrounds.
seq:
  - id: magic
    contents: 'Le'
  - id: decoded_size
    type: u4
  - id: stream
    size-eos: true
    doc: Flag-byte / token stream.
