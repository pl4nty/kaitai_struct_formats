# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/tvol.ksy
meta:
  id: koei_tecmo_tvol
  title: Koei Tecmo / Gust Texture Volume Archive (.tvol)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Koei Tecmo / Gust Texture Volume Archive. Each member's name is a
  NUL-terminated string stored inline at the start of its own data.

  There is no magic or separate name table: the file begins with a
  little-endian count followed by count pairs of absolute file offsets and
  byte lengths. Each payload includes its name bytes; extraction writes the
  entire payload, including that prefix, to a .bin file. Consequently the
  parsed body is not just the texture bytes after the name.

  It skips zero-length members and offsets at or past EOF; a member
  extending beyond EOF is truncated on extraction. A name is used only when
  at least 48 bytes remain from its offset: the extractor scans at most the
  first 47 bytes for a NUL, using a nonempty prefix as NAME.bin. Otherwise
  it uses tex_NNNN.bin, with NNNN the zero-based entry index. Those output
  names are not stored in a separate table. This Kaitai instance exposes the
  inline name but does not implement the extractor's bounds checks, fallback
  naming, or truncation.
seq:
  - id: num_textures
    type: u4
    doc: Number of offset/size descriptors; extractor accepts 1 through 10000.
  - id: entries
    type: entry_t
    repeat: expr
    repeat-expr: num_textures
types:
  entry_t:
    seq:
      - id: offset
        type: u4
        doc: Absolute file offset of the complete member, including its name.
      - id: size
        type: u4
        doc: Declared byte length of the complete member.
    instances:
      name:
        io: _root._io
        pos: offset
        size: 48
        type: str
        terminator: 0
        encoding: ASCII
        if: size != 0
        doc: Inline NUL-terminated name prefix; extractor considers at most 47 bytes.
      body:
        io: _root._io
        pos: offset
        size: size
        doc: Complete raw member, including the inline name prefix.
