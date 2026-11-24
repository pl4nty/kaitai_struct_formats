meta:
  id: outlook_pst
  title: Outlook Personal Folders file (PST), NDB layer header and BTrees
  application:
    - Microsoft Outlook
    - libpff
    - java-libpst
  file-extension: pst
  license: CC0-1.0
  ks-version: '0.11'
  endian: le
doc: |
  Outlook Personal Folders file, used by Microsoft Outlook to store
  messages, folders, contacts, calendar items and other mailbox data
  locally. The format has three layers: the node database (NDB) layer
  that stores nodes and blocks in a file and indexes them with two
  BTrees, the lists, tables and properties (LTP) layer built on top of
  it, and the messaging layer.

  This spec covers the NDB layer structures needed to navigate the file:
  the HEADER at offset 0 (in its ANSI and Unicode variants, told apart
  by `version`), the ROOT structure it contains, and the 512-byte BTree
  pages of the node BTree (NBT, mapping node IDs to data and subnode
  block IDs) and the block BTree (BBT, mapping block IDs to file
  offsets and sizes), reachable through `nbt_root` and `bbt_root`. Data
  blocks (which may be obfuscated as indicated by `crypt_method`), the
  allocation map pages and the LTP and messaging layers are not decoded.

  OST files with 4 KiB pages (`version` 36, `magic_client` "SO") are not
  described by the specification and are not covered.
doc-ref:
  - https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-pst/141923d5-15ab-4ef1-a524-6dce75aae546
  - https://officeprotocoldoc.z19.web.core.windows.net/files/MS-PST/%5bMS-PST%5d.pdf
seq:
  - id: magic
    contents: '!BDN'
  - id: crc_partial
    type: u4
    doc: CRC-32 of the 471 bytes starting at `magic_client` (offset 8).
  - id: magic_client
    contents: SM
  - id: version
    type: u2
    doc: |
      File format version: 14 or 15 for ANSI files, 23 or more for
      Unicode files (37: may be protected by Windows Information
      Protection).
  - id: version_client
    type: u2
    doc: Client file format version; 19.
  - id: platform_create
    type: u1
    doc: Always 1.
  - id: platform_access
    type: u1
    doc: Always 1.
  - id: reserved1
    type: u4
  - id: reserved2
    type: u4
  - id: header_rest
    type:
      switch-on: is_unicode
      cases:
        true: header_unicode
        false: header_ansi
instances:
  is_unicode:
    value: version >= 23
  root:
    value: 'is_unicode ? header_rest.as<header_unicode>.root : header_rest.as<header_ansi>.root'
  crypt_method:
    value: 'is_unicode ? header_rest.as<header_unicode>.crypt_method : header_rest.as<header_ansi>.crypt_method'
  nbt_root:
    pos: root.nbt.ib
    size: 512
    type: bt_page
    doc: Root page of the node BTree.
  bbt_root:
    pos: root.bbt.ib
    size: 512
    type: bt_page
    doc: Root page of the block BTree.
types:
  header_unicode:
    seq:
      - id: bid_unused
        type: u8
      - id: bid_next_page
        type: u8
        doc: Counter for the next page BID.
      - id: unique
        type: u4
        doc: Incremented on every header modification.
      - id: nid_counters
        type: nid
        repeat: expr
        repeat-expr: 32
        doc: |
          Last allocated NID for each of the 32 NID types, indexed by NID
          type.
      - id: unused
        type: u8
      - id: root
        type: root
      - id: align
        type: u4
      - id: free_map
        size: 128
        doc: Deprecated FMap; filled with 0xff.
      - id: free_page_map
        size: 128
        doc: Deprecated FPMap; filled with 0xff.
      - id: sentinel
        contents: [0x80]
      - id: crypt_method
        type: u1
        enum: crypt_method
      - id: reserved
        size: 2
      - id: bid_next_block
        type: u8
        doc: Counter for the next block BID (increments by 4).
      - id: crc_full
        type: u4
        doc: CRC-32 of the 516 bytes from `magic_client` to `bid_next_block`.
      - id: reserved2
        size: 3
      - id: reserved3
        type: u1
      - id: reserved4
        size: 32
  header_ansi:
    seq:
      - id: bid_next_block
        type: u4
        doc: Counter for the next block BID (increments by 4).
      - id: bid_next_page
        type: u4
        doc: Counter for the next page BID.
      - id: unique
        type: u4
        doc: Incremented on every header modification.
      - id: nid_counters
        type: nid
        repeat: expr
        repeat-expr: 32
        doc: |
          Last allocated NID for each of the 32 NID types, indexed by NID
          type.
      - id: root
        type: root
      - id: free_map
        size: 128
        doc: Deprecated FMap; filled with 0xff.
      - id: free_page_map
        size: 128
        doc: Deprecated FPMap; filled with 0xff.
      - id: sentinel
        contents: [0x80]
      - id: crypt_method
        type: u1
        enum: crypt_method
      - id: reserved
        size: 2
      - id: reserved2
        type: u8
      - id: reserved3
        type: u4
      - id: reserved4
        size: 3
      - id: reserved5
        type: u1
      - id: reserved6
        size: 32
  root:
    seq:
      - id: reserved
        type: u4
      - id: len_file
        type: file_ofs
        doc: Size of the file.
      - id: ofs_last_amap
        type: file_ofs
        doc: Offset of the last allocation map page.
      - id: amap_free
        type: file_ofs
        doc: Total free space in all allocation maps.
      - id: pmap_free
        type: file_ofs
        doc: Total free space in all page maps (deprecated; 0).
      - id: nbt
        type: bref
        doc: Root page of the node BTree.
      - id: bbt
        type: bref
        doc: Root page of the block BTree.
      - id: amap_valid
        type: u1
        enum: amap_valid
      - id: reserved2
        type: u1
      - id: reserved3
        type: u2
  file_ofs:
    doc: IB or byte count; 8 bytes in Unicode files, 4 bytes in ANSI files.
    seq:
      - id: value
        type:
          switch-on: _root.is_unicode
          cases:
            true: u8
            false: u4
  bid:
    doc: Block ID; 8 bytes in Unicode files, 4 bytes in ANSI files.
    seq:
      - id: value
        type:
          switch-on: _root.is_unicode
          cases:
            true: u8
            false: u4
    instances:
      is_internal:
        value: (value & 2) != 0
        doc: The block is an internal (XBLOCK/XXBLOCK/SLBLOCK/SIBLOCK) block.
      index:
        value: value >> 2
  nid:
    seq:
      - id: value
        type: u4
    instances:
      nid_type:
        value: value & 0x1f
        enum: nid_type
      index:
        value: value >> 5
  bref:
    doc: Maps a BID to its absolute file offset.
    seq:
      - id: bid
        type: bid
      - id: ib
        type:
          switch-on: _root.is_unicode
          cases:
            true: u8
            false: u4
  bt_page:
    doc: 512-byte BTree page (node BTree or block BTree).
    seq:
      - id: entries_data
        size: '_root.is_unicode ? 488 : 496'
      - id: num_entries
        type: u1
      - id: max_entries
        type: u1
      - id: len_entry
        type: u1
        doc: Size of each entry; entries are read in steps of this size.
      - id: level
        type: u1
        doc: 0 for leaf pages, greater than 0 for intermediate pages.
      - id: padding
        size: 4
        if: _root.is_unicode
      - id: trailer
        type: page_trailer
    instances:
      entry_kind:
        value: |
          level != 0 ? 0 :
          trailer.page_type == page_type::nbt ? 1 :
          trailer.page_type == page_type::bbt ? 2 : 3
      entries:
        pos: 0
        size: len_entry
        type:
          switch-on: entry_kind
          cases:
            0: bt_entry
            1: nbt_entry
            2: bbt_entry
        repeat: expr
        repeat-expr: num_entries
  page_trailer:
    seq:
      - id: page_type
        type: u1
        enum: page_type
      - id: page_type_repeat
        type: u1
        enum: page_type
      - id: signature
        type: u2
      - id: crc_unicode
        type: u4
        if: _root.is_unicode
        doc: CRC-32 of the page data before the trailer.
      - id: bid
        type: bid
      - id: crc_ansi
        type: u4
        if: not _root.is_unicode
        doc: CRC-32 of the page data before the trailer.
  bt_entry:
    doc: Intermediate entry pointing to a child BTree page.
    seq:
      - id: key
        type: file_ofs
        doc: |
          Lowest key (NID or BID) in the child page; a NID is zero-extended
          to 8 bytes in Unicode files.
      - id: child_ref
        type: bref
    instances:
      child:
        io: _root._io
        pos: child_ref.ib
        size: 512
        type: bt_page
  nbt_entry:
    doc: Leaf entry of the node BTree.
    seq:
      - id: nid
        type: nid
      - id: nid_padding
        size: 4
        if: _root.is_unicode
        doc: The NID is zero-extended to 8 bytes in Unicode files.
      - id: bid_data
        type: bid
        doc: Data block of the node.
      - id: bid_sub
        type: bid
        doc: Subnode block of the node, or 0.
      - id: nid_parent
        type: nid
        doc: Parent folder node for folder objects, otherwise 0.
  bbt_entry:
    doc: Leaf entry of the block BTree.
    seq:
      - id: block_ref
        type: bref
      - id: len_block
        type: u2
        doc: Size of the block's data, excluding trailer and padding.
      - id: num_refs
        type: u2
        doc: Reference count of the block.
enums:
  crypt_method:
    0x00: none
    0x01: permute
    0x02: cyclic
    0x10: edp_encrypted
  amap_valid:
    0: invalid
    1: valid_amap1
    2: valid_amap2
  page_type:
    0x80: bbt
    0x81: nbt
    0x82: fmap
    0x83: pmap
    0x84: amap
    0x85: fpmap
    0x86: dlist
  nid_type:
    0x00: hid
    0x01: internal
    0x02: normal_folder
    0x03: search_folder
    0x04: normal_message
    0x05: attachment
    0x06: search_update_queue
    0x07: search_criteria_object
    0x08: assoc_message
    0x0a: contents_table_index
    0x0c: outgoing_queue_table
    0x0d: hierarchy_table
    0x0e: contents_table
    0x0f: assoc_contents_table
    0x10: search_contents_table
    0x11: attachment_table
    0x12: recipient_table
    0x13: search_table_index
    0x1f: ltp
