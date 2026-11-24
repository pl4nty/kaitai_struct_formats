meta:
  id: unqlite_db
  title: UnQLite database
  application: UnQLite
  file-extension:
    - db
    - unqlite
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  UnQLite is an embedded key/value and document database engine by Symisc
  Systems. A database file is an array of fixed-size pages. Page 0 holds the
  database header written by the pager (signature, magic number, creation
  time, sector and page size, and the name of the key/value storage engine).

  With the default disk storage engine, `hash` (a linear hash table), page 1
  holds the hash header and the first part of the bucket map, which maps
  logical bucket numbers to the pages storing them. Each bucket page starts
  with a small header (offset of the first cell, offset of the first free
  block, number of the next "slave" page of the same bucket) and holds a
  linked list of cells, each describing one record. Payloads that do not fit
  in the page continue on overflow pages.

  This spec parses the database header, the hash header with its bucket map
  (page 1 only; continuation map pages are only located), the bucket pages
  referenced by the map with their slave pages, and the cells of each page.
  The key and value of a record are available when they are stored locally
  (no overflow page); overflow pages and the free page list are not followed.
  All integers are big-endian.
doc-ref:
  - https://github.com/symisc/unqlite/blob/8f601ccd7484e4a1d62725c07914d62c44ac12cc/src/pager.c#L1271-L1365
  - https://github.com/symisc/unqlite/blob/8f601ccd7484e4a1d62725c07914d62c44ac12cc/src/lhash_kv.c
seq:
  - id: header
    type: db_header
instances:
  is_lhash:
    value: header.kv_engine == "hash"
  hash_header:
    pos: header.page_size
    size: header.page_size
    type: lhash_header
    if: is_lhash
    doc: Page 1, the header of the linear hash storage engine.
types:
  db_header:
    seq:
      - id: signature
        contents: unqlite
      - id: magic
        contents: [0xdb, 0x7c, 0x27, 0x12]
      - id: creation_date
        type: u2
        doc: MS-DOS date (bits 9-15 year since 1980, bits 5-8 month, bits 0-4 day).
      - id: creation_time
        type: u2
        doc: MS-DOS time (bits 11-15 hour, bits 5-10 minute, bits 0-4 seconds / 2).
      - id: sector_size
        type: u4
      - id: page_size
        type: u4
        doc: Size of every page of the database, a power of two of at least 512.
      - id: len_kv_engine
        type: u2
      - id: kv_engine
        size: len_kv_engine
        type: str
        encoding: ASCII
        doc: Name of the key/value storage engine; `hash` for the default disk engine.
  lhash_header:
    seq:
      - id: magic
        contents: [0xfa, 0x78, 0x2d, 0xcb]
      - id: hash_check
        type: u4
        doc: Hash of the string `chm@symisc`, to check that the same hash function is used.
      - id: free_list_page
        type: u8
        doc: First page of the free page list, 0 if empty.
      - id: split_bucket
        type: u8
      - id: max_split_bucket
        type: u8
      - id: next_map_page
        type: u8
        doc: Next page of the bucket map, 0 if none.
      - id: num_map_records
        type: u4
        doc: Number of bucket map records stored in this page.
      - id: map_records
        type: bucket_map_record
        repeat: expr
        repeat-expr: num_map_records
  bucket_map_record:
    seq:
      - id: logical_bucket
        type: u8
      - id: real_page
        type: u8
    instances:
      bucket_page:
        io: _root._io
        pos: real_page * _root.header.page_size
        size: _root.header.page_size
        type: bucket_page
  bucket_page:
    seq:
      - id: ofs_first_cell
        type: u2
        doc: Offset of the first cell in this page, 0 if the page is empty.
      - id: ofs_first_free_block
        type: u2
      - id: slave_page
        type: u8
        doc: Next page of the same bucket, 0 if none.
    instances:
      first_cell:
        pos: ofs_first_cell
        type: cell
        if: ofs_first_cell != 0
      slave:
        io: _root._io
        pos: slave_page * _root.header.page_size
        size: _root.header.page_size
        type: bucket_page
        if: slave_page != 0
  cell:
    seq:
      - id: hash
        type: u4
      - id: len_key
        type: u4
      - id: len_value
        type: u8
      - id: ofs_next_cell
        type: u2
        doc: Offset of the next cell in the same page, 0 for the last one.
      - id: overflow_page
        type: u8
        doc: First overflow page holding the payload, 0 if the payload is stored locally.
      - id: key
        size: len_key
        if: overflow_page == 0
      - id: value
        size: len_value
        if: overflow_page == 0
    instances:
      next:
        pos: ofs_next_cell
        type: cell
        if: ofs_next_cell != 0
