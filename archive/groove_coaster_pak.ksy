# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/pak.ksy
meta:
  id: groove_coaster_pak
  title: Groove Coaster mobile resource archive
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Resource archive consumed by MtxFileManager. The layout was recovered from
  MtxFileManager::CreateFileTable and MtxFileManager::_isExistFile in the
  arm64-v8a libtune.so (SHA-256
  689b2e4c0bc4479a3f309944b5070796878c66c0dfdbd283c11ec0bbeeea9efa).

  The three gc2 samples use only storage_flags::stored. The meaning and codec
  for flag value 1 remain unverified because the game code does not take that
  branch for these archives.
seq:
  - id: payload_size
    type: u4
    valid:
      eq: _io.size - 4
    doc: Size of the remainder of the file, excluding this field.
  - id: index_stored_size
    type: u4
  - id: index_unpacked_size
    type: u4
  - id: index_flags
    type: u1
    enum: storage_flags
  - id: index
    size: index_stored_size
    type: file_table
    if: index_flags == storage_flags::stored
  - id: packed_index
    size: index_stored_size
    if: index_flags != storage_flags::stored
    doc: Raw index bytes for the unverified flag value.
  - id: data
    size-eos: true
    doc: Concatenated file payloads. Entry offsets are relative to this field.
enums:
  storage_flags:
    0: stored
    1: packed_unknown
types:
  file_table:
    seq:
      - id: num_files
        type: u2
      - id: entries
        type: file_entry(_index)
        repeat: expr
        repeat-expr: num_files
      - id: sentinel
        type: table_sentinel
        doc: Supplies the final filename and payload end offsets.
      - id: names
        size-eos: true
        doc: Concatenated UTF-8 names without terminators.
  file_entry:
    params:
      - id: idx
        type: u2
    seq:
      - id: name_offset
        type: u4
        doc: Offset from the start of the file table.
      - id: data_offset
        type: u4
        doc: Offset from the start of the archive data area.
      - id: unpacked_size
        type: u4
      - id: flags
        type: u1
        enum: storage_flags
    instances:
      next_name_offset:
        value: 'idx + 1 < _parent.entries.size ? _parent.entries[idx + 1].name_offset : _parent.sentinel.name_offset'
      next_data_offset:
        value: 'idx + 1 < _parent.entries.size ? _parent.entries[idx + 1].data_offset : _parent.sentinel.data_offset'
      stored_size:
        value: next_data_offset - data_offset
      name:
        pos: name_offset
        size: next_name_offset - name_offset
        type: str
        encoding: UTF-8
      raw_data:
        io: _root._io
        pos: 13 + _root.index_stored_size + data_offset
        size: stored_size
  table_sentinel:
    seq:
      - id: name_offset
        type: u4
        doc: End of the name pool; equal to the file table size in samples.
      - id: data_offset
        type: u4
        doc: End of the data area.
