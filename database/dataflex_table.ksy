# Imported from https://github.com/the-wondersmith/ferroflex/blob/e2f6a6a2a56903e6ab7bac9284a98d65b2ed4237/docs/kaitai-struct/table.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dataflex_table
  title: DataFlex v3 Database File
  application: DataFlex v3
  file-extension: dat
  license: AGPL-3.0-only
  ks-version: 0.9
  encoding: ASCII
  endian: le
  bit-endian: le
doc: A DataFlex flat-file table.
doc-ref: https://web.archive.org/web/20210115231834/hwiegman.home.xs4all.nl/fileformats/dat/DATAFLEX.txt
seq:
  - id: header
    size: 3072
    type: header
  - id: null_record
    size: header.record_length
  - id: record_blocks
    type: record_block
    repeat: expr
    repeat-expr: header.record_count - 1
    

enums:
  enabled_disabled:
    0: disabled
    1: enabled
  true_false:
    0: false
    1: true
  active_inactive:
    0: active
    1: inactive
  compression_type:
    0: none
    1: fast
    2: standard
    3: custom
  index_type:
    0: default
    1: descending_ascending
    2: uppercase
  field_type:
    0: ascii
    1: numeric
    2: date
    3: overlap
    5: text
    6: binary

types:
  index_definition:
    seq:
      - id: field_count
        type: u1
        doc: DOCUMENTATION NEEDED
      - id: field_numbers
        size: 16
        doc: DOCUMENTATION NEEDED
      - id: flag_byte
        type: u1
        enum: index_type
        doc: DOCUMENTATION NEEDED
  field_definition:
    seq:
      - id: offset
        type: u2le
        doc: DOCUMENTATION NEEDED
      - id: main_index
        type: b4
        doc: DOCUMENTATION NEEDED
      - id: decimal_points
        type: b4
        doc: DOCUMENTATION NEEDED
      - id: length
        type: u1
        doc: DOCUMENTATION NEEDED
      - id: type
        type: u1
        enum: field_type
        doc: DOCUMENTATION NEEDED
      - id: file_number
        type: u1
        doc: DOCUMENTATION NEEDED
      - id: field_number
        type: u2le
        doc: DOCUMENTATION NEEDED
  header:
    instances:
      higest_record_count_ever:
        pos: 0x00
        type: u4le
        doc: The total number of records that have ever been stored in a given table
      first_reused_record:
        pos: 0x04
        type: u4le
        doc: |
          Un-deciphered value, has something to do with reuse of deleted space.
          Should be 0 if deleted space is not re-used, but could possibly be the
          first available record # otherwise.
      record_count:
        pos: 0x08
        type: u4le
        doc: The total number of records currently in the table
      max_record_count:
        pos: 0x0C
        type: u4le
        doc: The total number of records the table can store at any given time
      header_integrity1:
        pos: 0x10
        type: u4le
        doc: |
          A flag value for header integrity. Should be 0 if header integrity
          is disabled, or a checksum value otherwise.
      checksum1:
        pos: 0x14
        type: u4le
        doc: A table / header integrity checksum value.
      checksum2:
        pos: 0x18
        type: u4le
        doc: A table / header integrity checksum value.
      table_version1:
        pos: 0x1C
        type: u1
        doc: The version of the table
      table_version2:
        pos: 0x1D
        type: u1
        doc: The version of the table
      static_zero1:
        pos: 0x1E
        type: u1
        doc: Should always be 0
      compression_type:
        pos: 0x1E
        type: u1
        enum: compression_type
        doc: The type of compression used by the table
      first_available_record:
        pos: 0x20
        type: u4le
        doc: The location of the first available record
      static_zero2:
        pos: 0x28
        type: u4le
        doc: Should be 0, use uknown if compresion is enabled
      static_zero3:
        pos: 0x30
        type: u4le
        doc: Should be 0, use uknown if compresion is enabled
      checksum3:
        pos: 0x38
        type: u4le
        doc: A table / header integrity checksum value.
      static_zero4:
        pos: 0x3C
        type: u4le
        doc: Should always be 0
      header_integrity2:
        pos: 0x40
        type: u1
        doc: |
          Should be 0 if header integrity is disabled, otherwise
          its use is unknown.
      file_locking1:
        pos: 0x41
        type: u1
        enum: enabled_disabled
        doc: Flag value for file locking. 1=True 0=false
      reuse_deleted_space:
        pos: 0x4A
        type: s2le
        doc: 0=Reuse deleted space -1= do not.  -1= Compression
      unknown_checksum1:
        pos: 0x4C
        type: s2le
        doc: 0=Reuse deleted space -1= do not.  -1= Compression
      checksum4:
        pos: 0x50
        type: u4le
        doc: A table / header integrity checksum value.
      record_remainder:
        pos: 0x98
        type: u2le
        doc: |
          Records until remainder block. Basically number of records per
          512 byte block or, 1 for anything that has no remainder blocks.
      record_length:
        pos: 0x9a
        type: u2le
        doc: The total number of bytes occuped by one record in the table
      reuse_deleted_records:
        pos: 0xA4
        type: u1
        enum: true_false
        doc: 0=Reuse deleted space -1= do not.  -1= Compression
      fields_per_record:
        pos: 0xA5
        type: u1
        doc: Number of fields per record.
      file_locking:
        pos: 0xA8
        type: u1
        enum: true_false
        doc: Flag value for if file locking is enabled.
      static_one1:
        pos: 0xA9
        type: u1
        doc: Unknown value, should always be 1.
      static_one2:
        pos: 0xAD
        type: u1
        doc: Unknown value, should always be 1.
      unknown_byte:
        pos: 0xAA
        type: u1
        doc: Unknown value.
      index_table:
        pos: 0xB0
        type: index_definition
        repeat: expr
        repeat-expr: 16
        doc: All of the indexes associated with the table
      table_name:
        pos: 0x2D0
        size: 16
        type: str
        encoding: ASCII
        doc: File root name, null padded to 16 bytes.
      fields:
        pos: 0x2E0
        type: field_definition
        repeat: expr
        repeat-expr: 256
        doc: Deffinitions of all the fields in the table
  record:
    seq:
      - id: record
        size: _root.header.record_length
  record_block:
    seq:
      - id: records
        type: record
        repeat: expr
        repeat-expr: _root.header.record_remainder
#      - id: padding
#        size: _root.header.record_remainder == 1 ? 0 : 12
