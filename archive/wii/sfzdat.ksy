# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/sfzdat.ksy
meta:
  id: sfzdat
  title: Nintendo DAT/SFZDAT flat resource table
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  "DAT\0" flat resource table, per lib-sfzdat.c. Names use a
  fixed-stride array (a u32 stride followed by that many
  fixed-width, NUL-padded records); when that does not fit the file,
  the reference reader falls back to packed NUL-terminated strings.
  Only the common strided case is modeled here.
seq:
  - id: magic
    contents: [0x44, 0x41, 0x54, 0x00]
  - id: num_files
    type: u4
  - id: offsets_offset
    type: u4
  - id: extensions_offset
    type: u4
  - id: names_offset
    type: u4
  - id: sizes_offset
    type: u4
instances:
  file_offsets:
    io: _io
    pos: offsets_offset
    type: u4
    repeat: expr
    repeat-expr: num_files
  file_sizes:
    io: _io
    pos: sizes_offset
    type: u4
    repeat: expr
    repeat-expr: num_files
  name_stride:
    io: _io
    pos: names_offset
    type: u4
  names:
    io: _io
    pos: names_offset + 4
    size: name_stride
    type: str
    terminator: 0
    encoding: ASCII
    repeat: expr
    repeat-expr: num_files
