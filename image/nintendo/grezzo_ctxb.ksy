# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/ctxb.ksy
meta:
  id: grezzo_ctxb
  title: Grezzo 3DS CTXB texture container
  file-extension: ctxb
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Grezzo 3DS texture container: a small header pointing at one `tex `
  chunk, which holds a table of texture entries whose pixel data
  (Pica200-tiled RGBA8 in 8x8 Z-order blocks) follows immediately after
  the chunk.

  The layout was derived from files with one chunk and one texture entry.
  `chunk_count` and `tex_count` are modelled as counts, but files with
  several entries have not been checked.
seq:
  - id: magic
    contents: "ctxb"
  - id: file_size
    type: u4
  - id: chunk_count
    type: u4
    doc: Number of chunks following the header; always 1 from this writer.
  - id: reserved
    type: u4
  - id: chunk_offset
    type: u4
    doc: File-relative offset of the first (only) chunk.
  - id: tex_data_offset
    type: u4
    doc: File-relative offset where raw texture pixel data begins.
instances:
  chunk:
    pos: chunk_offset
    type: tex_chunk
types:
  tex_chunk:
    seq:
      - id: magic
        contents: "tex "
      - id: section_size
        type: u4
        doc: Size of this chunk's entry table (36 bytes per entry from this writer).
      - id: tex_count
        type: u4
      - id: entries
        type: tex_entry
        repeat: expr
        repeat-expr: tex_count
  tex_entry:
    seq:
      - id: data_size
        type: u4
      - id: unknown1
        type: u2
      - id: unknown2
        type: u2
      - id: width
        type: u2
      - id: height
        type: u2
      - id: format
        type: u4
        doc: Pica200 texture format; the writer always emits 0x14016752 (RGBA8).
      - id: data_rel_offset
        type: u4
        doc: Offset of this entry's pixel data relative to the container's tex_data_offset.
      - id: name
        size: 16
        type: strz
        encoding: ASCII
        doc: Texture name, truncated to 15 characters plus NUL by the writer.
    instances:
      body:
        io: _root._io
        pos: _root.tex_data_offset + data_rel_offset
        size: data_size
