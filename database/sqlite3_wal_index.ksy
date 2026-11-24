meta:
  id: sqlite3_wal_index
  file-extension:
    - sqlite-shm
    - db-shm
    - db3-shm
    - sqlite3-shm
  license: CC0-1.0
doc: |
  SQLite3 is a popular serverless SQL engine, implemented as a library
  to be used within other applications. It keeps its databases as
  regular disk files.

  Write-Ahead Logging (WAL) is a journaling mode that enhances
  performance and allow more concurrency than the default rollback
  journal.

  The WAL Index is a shared memory object that allows faster lookup of
  pages stored in the WAL journal. Endianness of the stored values is
  platform-dependent: SQLite writes the native byte order of the host,
  which is detected here from the version field (always 3007000).
doc-ref:
  - https://www.sqlite.org/wal.html
  - https://sqlite.org/src/file?name=src/wal.c&ci=trunk
seq:
  - id: header
    type: header
  - id: header2
    type: header
  - id: ckpt_info
    type: ckpt_info
  - id: first_block
    type: index_block_one
  - id: index_blocks
    type: index_block
    repeat: eos
instances:
  version_le:
    pos: 0
    type: u4le
    doc: The version field read as little-endian, to detect the byte order.
types:
  header:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: version
        type: u4
      - id: reserved
        type: u4
      - id: change
        type: u4
      - id: init
        type: u1
      - id: big_end_cksum
        type: u1
      - id: page
        type: u2
      - id: mx_frame
        type: u4
      - id: n_page
        type: u4
      - id: frame_cksum_0
        type: u4
      - id: frame_cksum_1
        type: u4
      - id: salt_0
        type: u4
      - id: salt_1
        type: u4
      - id: cksum_0
        type: u4
      - id: cksum_1
        type: u4
  ckpt_info:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: n_backfill
        type: u4
      - id: read_mark
        type: read_mark_array
      - id: lock
        type: lock_array
      - id: n_backfill_attempted
        type: u4
      - id: not_used
        type: u4
  lock_array:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: lock
        type: u1
        repeat: expr
        repeat-expr: 8 # SQLITE_SHM_NLOCK
  read_mark_array:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: read_mark
        type: u4
        repeat: expr
        repeat-expr: 5 # WAL_NREADER
  index_block_one:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: page_mapping
        type: page_mapping_one
      - id: hash_table
        type: hash_table
  page_mapping_one:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: page_number
        type: u4
        repeat: expr
        repeat-expr: 4062 # HASHTABLE_NPAGE_ONE
  index_block:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: page_mapping
        type: page_mapping
      - id: hash_table
        type: hash_table
  page_mapping:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: page_number
        type: u4
        repeat: expr
        repeat-expr: 4096 # HASHTABLE_NPAGE
  hash_table:
    meta:
      endian:
        switch-on: _root.version_le == 3007000
        cases:
          true: le
          false: be
    seq:
      - id: hash
        type: u2
        repeat: expr
        repeat-expr: 2*4096 # HASHTABLE_NSLOT
