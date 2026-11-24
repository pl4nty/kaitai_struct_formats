# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/ccf.ksy
meta:
  id: wii_vc_ccf
  title: Wii Virtual Console CCF archive
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Wii Virtual Console "CCF" flat archive. Optional per-entry zlib (standard,
  not raw-deflate) compression; a member is stored raw when size ==
  decompressed_size.

  The 32-byte header is followed immediately by num_files 32-byte
  descriptors. Offsets in those descriptors are multiplied by the header's
  offset_multiplier to obtain absolute file positions. There is no explicit
  data-start pointer; members may be separated by alignment padding.

  It copies all 20 filename bytes and appends a NUL if no terminator is
  present. When the stored and decompressed sizes differ, decoding expects a
  complete standard zlib stream that produces exactly decompressed_size
  bytes; this schema exposes the stored stream without inflating it.

  With compression enabled, it tries zlib level 6 only for inputs longer
  than 32 bytes and keeps the compressed stream only if it is smaller. These
  are writer choices, not requirements for other CCF files.
seq:
  - id: magic
    contents: "CCF\0"
  - id: unknown_04
    size: 12
    doc: Reserved header bytes.
  - id: offset_multiplier
    type: u4
    doc: Unit size for entry offsets.
  - id: num_files
    type: u4
    doc: Descriptor count.
  - id: unknown_18
    size: 8
    doc: Reserved header bytes.
  - id: entries
    type: entry_t
    repeat: expr
    repeat-expr: num_files
types:
  entry_t:
    seq:
      - id: name
        size: 20
        type: str
        terminator: 0
        encoding: ASCII
        doc: Fixed-width filename bytes; may occupy all 20 bytes without a NUL.
      - id: offset_units
        type: u4
        doc: Payload file position measured in offset_multiplier-sized units.
      - id: size
        type: u4
        doc: Stored payload byte length, compressed or raw.
      - id: decompressed_size
        type: u4
        doc: Expected decoded length; equality with size signals raw storage.
    instances:
      offset:
        value: offset_units * _root.offset_multiplier
        doc: Absolute byte offset of this member's stored payload.
      body:
        io: _root._io
        pos: offset
        size: size
        doc: Stored member bytes; zlib decoding is not performed here.
