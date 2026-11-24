# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/stpk.ksy
meta:
  id: jump_stars_stpk
  title: Jump Super Stars / Jump Ultimate Stars DS archive (STPK)
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Jump Super Stars / Jump Ultimate Stars DS archive (.srd/.stpk). The first
  0x10 bytes are followed by a directory of 0x30-byte resource records; each
  payload position is an absolute file offset.

  It clamps a payload that extends past EOF to the remaining bytes, and does
  not extract an entry whose start is at or beyond EOF or whose clamped
  length is zero. An empty name becomes `res_NNNN.bin` at extraction. The
  writer sorts input names, drops directory prefixes, stores at most 31
  filename bytes plus a NUL in each 32-byte slot, and aligns the first and
  each following payload to 16 bytes. Its header words at 0x04 and 0x0c are
  1 and 0 respectively, but the reader does not validate them.
seq:
  - id: magic
    contents: "STPK"
    doc: Four-byte ASCII archive signature.
  - id: unknown_04
    size: 4
    doc: Header word, usually big-endian 1; its meaning is not established.
  - id: num_resources
    type: u4
    doc: Number of 0x30-byte resource records beginning at offset 0x10.
  - id: unknown_0c
    size: 4
    doc: Reader ignores it.
  - id: entries
    type: entry_t
    repeat: expr
    repeat-expr: num_resources
types:
  entry_t:
    seq:
      - id: offset
        type: u4
        doc: Absolute byte offset of this member's payload.
      - id: size
        type: u4
        doc: Declared payload byte length before the reader's EOF clamping.
      - id: unknown_08
        size: 8
        doc: Unknown record bytes at offsets 0x08..0x0f; writer zeros them.
      - id: name
        size: 0x30 - 0x10
        type: str
        terminator: 0
        encoding: ASCII
        doc: |
          NUL-terminated filename in a fixed 32-byte slot. The canonical
          writer stores a basename and truncates it to 31 bytes.
    instances:
      body:
        io: _root._io
        pos: offset
        size: size
        doc: Raw member bytes addressed by the absolute offset and length.
