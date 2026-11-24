# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/smashpac.ksy
meta:
  id: smash4_pac
  title: Super Smash Bros. 4 animation container (.pac)
  license: LicenseRef-All-Rights-Reserved
doc: |
  PACK uses little-endian integers; KCAP uses big-endian integers. This is
  unrelated to the Nd Cube PAC\0, HAL ARC\0, and Mario Kart Arcade PAC
  containers.

  The 16-byte header is followed by three parallel, count-element u32 tables:
  absolute name offsets, absolute payload offsets, and payload byte lengths.
  Table index, not file order, associates each name with its payload. Names
  are NUL-terminated. Payloads are opaque here; their extensions identify
  the nested animation format.

  Its writer emits both reserved words as zero, places names immediately
  after the tables, then aligns each payload start to a 16-byte boundary.
  Alignment and name placement describe writer output, not requirements of
  the reader.
seq:
  - id: magic
    size: 4
    type: str
    encoding: ASCII
    doc: PACK selects little-endian tables; KCAP selects big-endian tables.
  - id: content
    type: content_t(magic == "PACK")
types:
  content_t:
    meta:
      endian:
        switch-on: is_little_endian
        cases:
          true: le
          false: be
    params:
      - id: is_little_endian
        type: b1
    seq:
      - id: reserved_04
        type: u4
        doc: Unknown header word.
      - id: num_entries
        type: u4
        valid:
          max: 100000
        doc: Number of elements in each of the three parallel tables.
      - id: reserved_0c
        type: u4
        doc: Unknown header word.
      - id: name_offsets
        type: u4
        repeat: expr
        repeat-expr: num_entries
        doc: Absolute offsets to NUL-terminated member names.
      - id: data_offsets
        type: u4
        repeat: expr
        repeat-expr: num_entries
        doc: Absolute member payload offsets; writer aligns these to 16 bytes.
      - id: sizes
        type: u4
        repeat: expr
        repeat-expr: num_entries
        doc: Payload byte lengths, paired with offsets and names by table index.
      - id: entries
        type: member_t(name_offsets[_index], data_offsets[_index], sizes[_index])
        repeat: expr
        repeat-expr: num_entries
        doc: One logical member per table index; consumes no inline bytes.
    types:
      member_t:
        params:
          - id: name_offset
            type: u4
          - id: data_offset
            type: u4
          - id: data_size
            type: u4
        instances:
          name:
            io: _root._io
            pos: name_offset
            type: str
            terminator: 0
            encoding: UTF-8
            doc: Name resolved using its absolute offset; no fixed width.
          body:
            io: _root._io
            pos: data_offset
            size: data_size
            doc: Opaque payload, possibly zero-length.
