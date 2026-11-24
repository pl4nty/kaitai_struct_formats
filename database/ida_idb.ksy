meta:
  id: ida_idb
  title: IDA Pro database (IDB / I64)
  application: IDA Pro
  file-extension:
    - idb
    - i64
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Packed database file written by the IDA Pro disassembler when a database is
  closed: `.idb` for 32-bit databases (signature `IDA1`, or `IDA0` in very old
  versions) and `.i64` for 64-bit ones (`IDA2`).

  The file header gives the offsets of up to six sections, in this order:
  ID0 (a B-tree holding the netnodes, i.e. almost all of the analysis
  information), ID1 (flags for each byte of the program), NAM (list of named
  addresses), SEG (unused, normally absent), TIL (type library) and ID2. A
  zero offset means the section is not present. Each section is a
  compression method and a length, followed by the (possibly zlib-compressed)
  contents.

  This spec parses the file header, the section headers and contents
  (decompressing zlib-compressed sections), and the ID0 B-tree: its header and
  the pages reachable from the root page, with their entries. Keys in leaf
  pages are prefix-compressed: each key only stores the bytes after the
  `common_prefix` bytes it shares with the previous key of the page. The
  ID1, NAM, TIL and ID2 sections are exposed as raw contents.

  The file header format follows python-idb; header version 6 (IDA 6.x and
  later) uses 64-bit section offsets and lengths, older versions 32-bit ones.
doc-ref:
  - https://github.com/williballenthin/python-idb/blob/5a313f27cf6200e2454eb08ef3b557227fc2e9d7/idb/fileformat.py
  - https://github.com/nlitsme/idbutil/blob/6389deb71f670dbe4a021462eb558035f73773b8/IDB-FORMAT.md
seq:
  - id: header
    type: file_header
instances:
  version:
    pos: 0x1e
    type: u2
    doc: |
      Header version: 6 for databases written by IDA 6.x and later, smaller values for
      older ones.
  is_wide:
    value: version > 4
    doc: True if section offsets and lengths are 64-bit.
  id0:
    pos: header.ofs_id0
    type: section(section_kind::id0)
    if: header.ofs_id0 != 0
  id1:
    pos: header.ofs_id1
    type: section(section_kind::id1)
    if: header.ofs_id1 != 0
  nam:
    pos: header.ofs_nam
    type: section(section_kind::nam)
    if: header.ofs_nam != 0
  seg:
    pos: header.ofs_seg
    type: section(section_kind::seg)
    if: header.ofs_seg != 0
  til:
    pos: header.ofs_til
    type: section(section_kind::til)
    if: header.ofs_til != 0
  id2:
    pos: header.ofs_id2
    type: section(section_kind::id2)
    if: header.ofs_id2 != 0
types:
  file_header:
    seq:
      - id: signature
        size: 4
        type: str
        encoding: ASCII
        valid:
          any-of: ['"IDA0"', '"IDA1"', '"IDA2"']
        doc: '`IDA2` for 64-bit databases (`.i64`), `IDA1` or `IDA0` for 32-bit ones.'
      - id: unknown1
        type: u2
      - id: narrow
        type: narrow_offsets
        if: not _root.is_wide
      - id: wide
        type: wide_offsets
        if: _root.is_wide
    instances:
      ofs_id0:
        value: '_root.is_wide ? wide.ofs_id0 : narrow.ofs_id0'
      ofs_id1:
        value: '_root.is_wide ? wide.ofs_id1 : narrow.ofs_id1'
      ofs_nam:
        value: '_root.is_wide ? wide.ofs_nam : narrow.ofs_nam'
      ofs_seg:
        value: '_root.is_wide ? wide.ofs_seg : narrow.ofs_seg'
      ofs_til:
        value: '_root.is_wide ? wide.ofs_til : narrow.ofs_til'
      ofs_id2:
        value: |
          _root.is_wide ? wide.ofs_id2
            : narrow.has_id2 ? narrow.ofs_id2 : 0
  narrow_offsets:
    seq:
      - id: ofs_id0
        type: u4
      - id: ofs_id1
        type: u4
      - id: ofs_nam
        type: u4
      - id: ofs_seg
        type: u4
      - id: ofs_til
        type: u4
      - id: signature2
        contents: [0xdd, 0xcc, 0xbb, 0xaa]
      - id: version
        type: u2
      - id: unknown2
        type: u4
      - id: checksum_id0
        type: u4
      - id: checksum_id1
        type: u4
      - id: checksum_nam
        type: u4
      - id: checksum_seg
        type: u4
      - id: checksum_til
        type: u4
      - id: ofs_id2_raw
        type: u4
        if: has_id2
      - id: checksum_id2
        type: u4
        if: has_id2
    instances:
      has_id2:
        value: ofs_id0 == 0 or ofs_id0 >= 0x40
        doc: |
          In old databases (e.g. header version 1, written by IDA 5.0), the first
          section starts at offset 0x3e, before the place of these fields, and there is
          no ID2 section.
      ofs_id2:
        value: 'has_id2 ? ofs_id2_raw : 0'
  wide_offsets:
    seq:
      - id: ofs_id0
        type: u8
      - id: ofs_id1
        type: u8
      - id: unknown2
        type: u4
      - id: signature2
        contents: [0xdd, 0xcc, 0xbb, 0xaa]
      - id: version
        type: u2
      - id: ofs_nam
        type: u8
      - id: ofs_seg
        type: u8
      - id: ofs_til
        type: u8
      - id: checksum_id0
        type: u4
      - id: checksum_id1
        type: u4
      - id: checksum_nam
        type: u4
      - id: checksum_seg
        type: u4
      - id: checksum_til
        type: u4
      - id: ofs_id2
        type: u8
      - id: checksum_id2
        type: u4
  section:
    params:
      - id: kind
        type: u1
        enum: section_kind
    seq:
      - id: compression_method
        type: u1
        enum: compression_method
      - id: len_contents_narrow
        type: u4
        if: not _root.is_wide
      - id: len_contents_wide
        type: u8
        if: _root.is_wide
      - id: contents
        size: len_contents
        type:
          switch-on: kind
          cases:
            section_kind::id0: id0
        if: compression_method == compression_method::none
      - id: contents_zlib
        size: len_contents
        type:
          switch-on: kind
          cases:
            section_kind::id0: id0
        process: zlib
        if: compression_method == compression_method::zlib
    instances:
      len_contents:
        value: '_root.is_wide ? len_contents_wide : len_contents_narrow'
        doc: Length of the stored (possibly compressed) contents.
      btree:
        value: |
          (compression_method == compression_method::zlib ? contents_zlib : contents).as<id0>
        if: kind == section_kind::id0
        doc: The parsed ID0 B-tree header.
      btree_root:
        io: btree._io
        pos: btree.root_page_num * btree.page_size
        size: btree.page_size
        type: page(btree)
        if: kind == section_kind::id0 and btree.root_page_num != 0
        doc: The root page of the ID0 B-tree.
  id0:
    doc: |
      B-tree made of fixed-size pages. Page 0 holds this header; the other
      pages are tree nodes, numbered by their position in the section.
    seq:
      - id: ofs_next_free
        type: u4
      - id: page_size
        type: u2
      - id: root_page_num
        type: u4
      - id: num_records
        type: u4
      - id: num_pages
        type: u4
      - id: unknown1
        type: u1
      - id: signature
        size: 25
        type: strz
        encoding: ASCII
        doc: '`B-tree v2` (IDA 6.95 and later), `B-tree v 1.6 (C) Pol 1990` or a 1.5 variant.'
    instances:
      btree_version:
        value: |
          signature.substring(0, 9) == "B-tree v2" ? 20
            : signature.substring(0, 12) == "B-tree v 1.6" ? 16
            : 15
        doc: B-tree version times ten (20, 16 or 15).
  page:
    params:
      - id: btree
        type: id0
    seq:
      - id: first_child_num_wide
        type: u4
        if: btree_version >= 16
      - id: first_child_num_narrow
        type: u2
        if: btree_version < 16
      - id: num_entries
        type: u2
      - id: entries
        type:
          switch-on: is_leaf
          cases:
            true: leaf_pointer(btree.btree_version)
            false: branch_pointer(btree)
        repeat: expr
        repeat-expr: num_entries
        doc: Fixed-size pointers to the entries, which are stored in the rest of the page.
    instances:
      first_child_num:
        value: 'btree_version >= 16 ? first_child_num_wide : first_child_num_narrow'
        doc: Page holding the keys smaller than the first entry's key; 0 for a leaf page.
      btree_version:
        value: btree.btree_version
      is_leaf:
        value: first_child_num == 0
      first_child:
        io: btree._io
        pos: first_child_num * btree.page_size
        size: btree.page_size
        type: page(btree)
        if: not is_leaf
  branch_pointer:
    params:
      - id: btree
        type: id0
    seq:
      - id: child_num_wide
        type: u4
        if: btree_version >= 16
      - id: child_num_narrow
        type: u2
        if: btree_version < 16
      - id: ofs_entry_raw
        type: u2
    instances:
      child_num:
        value: 'btree_version >= 16 ? child_num_wide : child_num_narrow'
        doc: Page holding the keys between this entry's key and the next one's.
      child:
        io: btree._io
        pos: child_num * btree.page_size
        size: btree.page_size
        type: page(btree)
      btree_version:
        value: btree.btree_version
      ofs_entry:
        value: 'btree_version == 20 ? ofs_entry_raw : ofs_entry_raw + 1'
        doc: Offset of the entry in the page.
      entry:
        io: _parent._io
        pos: ofs_entry
        type: entry
  leaf_pointer:
    params:
      - id: btree_version
        type: u1
    seq:
      - id: common_prefix_wide
        type: u2
        if: btree_version == 20
      - id: common_prefix_narrow
        type: u1
        if: btree_version != 20
      - id: unknown1
        type: u1
        if: btree_version != 20
      - id: unknown2
        type: u2
        if: btree_version >= 16
      - id: ofs_entry_raw
        type: u2
    instances:
      common_prefix:
        value: 'btree_version == 20 ? common_prefix_wide : common_prefix_narrow'
        doc: |
          Number of leading bytes this entry's key shares with the previous entry's key;
          only the remaining bytes are stored.
      ofs_entry:
        value: 'btree_version == 20 ? ofs_entry_raw : ofs_entry_raw + 1'
        doc: Offset of the entry in the page.
      entry:
        io: _parent._io
        pos: ofs_entry
        type: entry
  entry:
    seq:
      - id: len_key
        type: u2
      - id: key
        size: len_key
      - id: len_value
        type: u2
      - id: value
        size: len_value
enums:
  section_kind:
    0: id0
    1: id1
    2: nam
    3: seg
    4: til
    5: id2
  compression_method:
    0: none
    2: zlib
