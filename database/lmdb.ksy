meta:
  id: lmdb
  title: Lightning Memory-Mapped Database (LMDB) data file
  application: LMDB
  file-extension: mdb
  xref:
    wikidata: Q6548043
  license: CC0-1.0
  ks-version: '0.11'
  endian: le
doc: |
  Data file (`data.mdb`) of the Lightning Memory-Mapped Database, a
  copy-on-write B+tree key-value store. The file is a sequence of pages
  of a fixed size (stored in the meta pages, commonly 4096). Pages 0
  and 1 are meta pages, each describing a snapshot; the one with the
  higher transaction ID is current. Each meta page references the
  root pages of the free-page database and the main database; named
  databases are leaf entries of the main database flagged as
  sub-databases.

  LMDB writes its structures in host byte order and with host pointer
  size. This spec assumes the common layout of 64-bit little-endian
  hosts and a non-MDB_DEVEL build (data format version 1).

  Coverage: meta pages, B+tree page headers, branch and leaf nodes
  (with keys, inline data, overflow page references and sub-database
  records), LEAF2 pages and overflow pages. Use `page(pgno)` on
  `page_number` values to follow the tree from `current_meta.main_db.root`.
doc-ref: https://github.com/LMDB/lmdb/blob/74dd6c3ec648c31857fe0a100f11c2a34619e2d7/libraries/liblmdb/mdb.c
seq:
  - id: meta_page_0
    type: meta_page
instances:
  page_size:
    value: meta_page_0.meta.free_db.pad
    doc: Page size, stored in the `md_pad` field of the free database record.
  meta_page_1:
    pos: page_size
    size: page_size
    type: meta_page
  current_meta:
    value: |
      meta_page_1.meta.txn_id > meta_page_0.meta.txn_id
      ? meta_page_1.meta
      : meta_page_0.meta
    doc: The meta of the most recently committed transaction.
types:
  page_header:
    -orig-id: MDB_page
    seq:
      - id: page_number
        -orig-id: mp_pgno
        type: u8
      - id: pad
        -orig-id: mp_pad
        type: u2
        doc: Key size if this is a LEAF2 page.
      - id: flags
        -orig-id: mp_flags
        type: page_flags
      - id: lower
        -orig-id: mp_lower
        type: u2
        if: not flags.overflow
        doc: Lower bound of free space (end of the node pointer array).
      - id: upper
        -orig-id: mp_upper
        type: u2
        if: not flags.overflow
        doc: Upper bound of free space (start of the node area).
      - id: num_overflow_pages
        -orig-id: mp_pages
        type: u4
        if: flags.overflow
    instances:
      num_keys:
        value: '(lower - 16) >> 1'
        if: not flags.overflow
  page_flags:
    meta:
      bit-endian: le
    seq:
      - id: branch
        -orig-id: P_BRANCH
        type: b1
      - id: leaf
        -orig-id: P_LEAF
        type: b1
      - id: overflow
        -orig-id: P_OVERFLOW
        type: b1
      - id: meta
        -orig-id: P_META
        type: b1
      - id: dirty
        -orig-id: P_DIRTY
        type: b1
      - id: leaf2
        -orig-id: P_LEAF2
        type: b1
        doc: Keys of a MDB_DUPFIXED sub-database stored without node headers.
      - id: sub_page
        -orig-id: P_SUBP
        type: b1
      - id: reserved
        type: b7
      - id: loose
        -orig-id: P_LOOSE
        type: b1
      - id: keep
        -orig-id: P_KEEP
        type: b1
  meta_page:
    seq:
      - id: header
        type: page_header
      - id: meta
        type: meta
  meta:
    -orig-id: MDB_meta
    seq:
      - id: magic
        -orig-id: mm_magic
        contents: [0xde, 0xc0, 0xef, 0xbe]
      - id: version
        -orig-id: mm_version
        type: u4
        doc: Data format version; 1 for release builds.
      - id: address
        -orig-id: mm_address
        type: u8
        doc: Address for a fixed mapping (MDB_FIXEDMAP), otherwise 0.
      - id: map_size
        -orig-id: mm_mapsize
        type: u8
      - id: free_db
        type: db
        doc: |
          Database of free pages. Its `pad` holds the page size and its
          `flags` the persistent environment flags.
      - id: main_db
        type: db
      - id: last_page_number
        -orig-id: mm_last_pg
        type: u8
      - id: txn_id
        -orig-id: mm_txnid
        type: u8
        doc: ID of the transaction that committed this meta page.
  db:
    -orig-id: MDB_db
    seq:
      - id: pad
        -orig-id: md_pad
        type: u4
        doc: Key size for LEAF2 pages (page size for the free database).
      - id: flags
        -orig-id: md_flags
        type: u2
        doc: |
          Database flags: 0x02 MDB_REVERSEKEY, 0x04 MDB_DUPSORT,
          0x08 MDB_INTEGERKEY, 0x10 MDB_DUPFIXED, 0x20 MDB_INTEGERDUP,
          0x40 MDB_REVERSEDUP.
      - id: depth
        -orig-id: md_depth
        type: u2
      - id: num_branch_pages
        -orig-id: md_branch_pages
        type: u8
      - id: num_leaf_pages
        -orig-id: md_leaf_pages
        type: u8
      - id: num_overflow_pages
        -orig-id: md_overflow_pages
        type: u8
      - id: num_entries
        -orig-id: md_entries
        type: u8
      - id: root
        -orig-id: md_root
        type: u8
        doc: Root page number, or 0xffff_ffff_ffff_ffff for an empty tree.
    instances:
      is_empty:
        value: root == 0xffff_ffff_ffff_ffff
      root_page:
        type: page(root)
        if: not is_empty
  page:
    params:
      - id: page_number
        type: u8
    instances:
      body:
        io: _root._io
        pos: page_number * _root.page_size
        size: _root.page_size
        type: tree_page
  tree_page:
    seq:
      - id: header
        type: page_header
      - id: node_offsets
        -orig-id: mp_ptrs
        type: u2
        repeat: expr
        repeat-expr: header.num_keys
        if: not header.flags.overflow and not header.flags.leaf2
        doc: Offsets of the nodes, relative to the start of the page.
      - id: leaf2_keys
        size: header.pad
        repeat: expr
        repeat-expr: header.num_keys
        if: header.flags.leaf2
    instances:
      nodes:
        type: node(node_offsets[_index], header.flags.branch)
        repeat: expr
        repeat-expr: header.num_keys
        if: not header.flags.overflow and not header.flags.leaf2
      overflow_data:
        io: _root._io
        pos: header.page_number * _root.page_size + 16
        size: header.num_overflow_pages * _root.page_size - 16
        if: header.flags.overflow
        doc: |
          Contents of an overflow page run; the actual value length is
          given by the leaf node that refers to it.
  node:
    -orig-id: MDB_node
    params:
      - id: ofs_node
        type: u2
      - id: is_branch
        type: bool
    instances:
      body:
        pos: ofs_node
        type: node_body(is_branch)
  node_body:
    params:
      - id: is_branch
        type: bool
    seq:
      - id: lo
        -orig-id: mn_lo
        type: u2
      - id: hi
        -orig-id: mn_hi
        type: u2
      - id: flags
        -orig-id: mn_flags
        type: u2
        doc: |
          For leaf nodes: 0x01 F_BIGDATA (data is on overflow pages),
          0x02 F_SUBDATA (data is a sub-database record), 0x04
          F_DUPDATA (data holds duplicates). For branch nodes on 64-bit
          hosts: bits 32..47 of the child page number.
      - id: len_key
        -orig-id: mn_ksize
        type: u2
      - id: key
        size: len_key
      - id: overflow_page_number
        type: u8
        if: not is_branch and is_big_data
        doc: First page of the overflow page run holding the value.
      - id: data
        size: len_data
        if: not is_branch and not is_big_data and not is_sub_db
        doc: Inline value (for F_DUPDATA, a sub-page of duplicates).
      - id: sub_db
        type: db
        if: not is_branch and is_sub_db
        doc: Record of a named database or of a duplicates sub-database.
    instances:
      len_data:
        value: (hi.as<u4> << 16) | lo
        if: not is_branch
      is_big_data:
        value: (flags & 1) != 0
      is_sub_db:
        value: (flags & 2) != 0
      child_page_number:
        value: lo | (hi.as<u8> << 16) | (flags.as<u8> << 32)
        if: is_branch
      child:
        type: page(child_page_number)
        if: is_branch
      overflow:
        type: page(overflow_page_number)
        if: not is_branch and is_big_data
