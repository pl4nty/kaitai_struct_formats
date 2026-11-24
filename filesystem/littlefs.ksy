meta:
  id: littlefs
  title: littlefs (little fail-safe filesystem) version 2
  application: littlefs
  file-extension:
    - img
    - bin
  license: CC0-1.0
  ks-version: '0.11'
  encoding: ASCII
  endian: le
doc: |
  littlefs is a small fail-safe filesystem for microcontrollers with flash
  storage. The device is divided into blocks of equal size. All metadata is
  kept in metadata pairs (two blocks that are written alternately); the
  superblock entry and the root directory live in the pair at blocks 0 and 1.

  Each metadata block holds a 32-bit revision count followed by an
  append-only log of commits. A commit is a list of entries, each a 32-bit
  big-endian tag followed by its data; every stored tag is XORed with the
  previous (decoded) tag, starting with 0xFFFFFFFF, and each commit ends with
  a CRC tag. The CRC tag's lowest chunk bit flips the expected valid bit of
  the following tags, so that unwritten (erased) storage decodes as an
  invalid tag, which ends the log.

  This spec reads the superblock entry from the beginning of block 0 (where
  littlefs keeps the superblock name tag and the superblock inline-struct
  tag after formatting or compacting), decodes the tag logs of the metadata
  blocks of the superblock pair, and follows directory and tail pointers to
  other metadata pairs on demand. File data stored in CTZ skip-lists is not
  read; inline file data and user attributes are left raw.

  A reader still has to pick the block with the newer revision count
  (sequence comparison) within each pair, check the commit CRCs (CRC-32,
  polynomial 0x04C11DB7, initial value 0xFFFFFFFF, over the revision count or
  previous CRC tag up to and including the CRC tag), and apply the entries in
  order, as later tags supersede earlier ones. Entries of a commit whose CRC
  does not match are still listed here.
doc-ref:
  - https://github.com/ARMmbed/littlefs/blob/6cb4e86540eca0d9ba62500a298385c9d863c8be/SPEC.md
  - https://github.com/ARMmbed/littlefs/blob/6cb4e86540eca0d9ba62500a298385c9d863c8be/lfs.c
seq:
  - id: superblock
    type: superblock
    doc: Copy of the superblock entry at the start of block 0.
instances:
  block_size:
    value: superblock.block_size
  superblock_pair:
    type: metadata_pair(0, 1)
    doc: Metadata pair holding the superblock entry, the start of the root directory.
types:
  superblock:
    seq:
      - id: revision
        type: u4
      - id: name_tag
        type: u4be
        valid: 0xf00f_fff7
        doc: |
          Superblock name tag (type 0x0ff, id 0, size 8: 0x0FF00008) XORed
          with 0xFFFFFFFF.
      - id: magic
        contents: littlefs
      - id: struct_tag
        type: u4be
        valid: 0x2fe0_0010
        doc: |
          Superblock inline-struct tag (type 0x201, id 0, size 24: 0x20100018)
          XORed with the decoded name tag.
      - id: version_minor
        type: u2
      - id: version_major
        type: u2
        valid: 2
      - id: block_size
        type: u4
      - id: block_count
        type: u4
      - id: name_max
        type: u4
        doc: Maximum file name length.
      - id: file_max
        type: u4
        doc: Maximum file size.
      - id: attr_max
        type: u4
        doc: Maximum user attribute size.
  metadata_pair:
    params:
      - id: block_a
        type: u4
      - id: block_b
        type: u4
    instances:
      first:
        io: _root._io
        pos: block_a * _root.block_size
        size: _root.block_size
        type: metadata_block
        if: block_a != 0xffff_ffff
      second:
        io: _root._io
        pos: block_b * _root.block_size
        size: _root.block_size
        type: metadata_block
        if: block_b != 0xffff_ffff
  metadata_block:
    seq:
      - id: revision
        type: u4
        doc: Incremented on every erase; the block with the newer revision is current.
      - id: entries
        type: 'entry(_index == 0 ? 0xffff_ffff : entries[_index - 1].next_xor)'
        repeat: until
        repeat-until: not _.is_valid or _io.size - _io.pos < 4
        doc: |
          Log entries of all commits. The last entry is the first invalid
          one (unwritten storage), unless the log fills the block.
  entry:
    params:
      - id: prev_tag
        type: u4
        doc: Decoded previous tag, with the valid bit flipped after a CRC tag.
    seq:
      - id: raw_tag
        type: u4be
      - id: body
        size: len_data
        type:
          switch-on: 'is_deleted ? 0 : type.to_i'
          cases:
            0x001: name
            0x002: name
            0x0ff: name
            0x200: metadata_pair_ptr
            0x202: ctz_struct
            0x500: crc
            0x501: crc
            0x5ff: fcrc
            0x600: metadata_pair_ptr
            0x601: metadata_pair_ptr
            0x7ff: move_state
        if: is_valid
    instances:
      tag:
        value: raw_tag ^ prev_tag
      is_valid:
        value: tag & 0x8000_0000 == 0 and len_data <= _io.size - _io.pos
        doc: |
          The valid bit is clear and the data fits in the block. An invalid
          tag ends the log.
      type:
        value: (tag >> 20) & 0x7ff
        enum: tag_type
        doc: |
          11-bit type (type3), made of the abstract type (`type1`) and the
          `chunk` field. Types with type1 0 (names) carry the file type in
          the chunk; 0x3xx are user attributes with the attribute type in the
          chunk.
      type1:
        value: (tag >> 28) & 0x7
      chunk:
        value: (tag >> 20) & 0xff
      id:
        value: (tag >> 10) & 0x3ff
        doc: File id within the metadata pair; 0x3FF for entries not tied to a file.
      len_raw:
        value: tag & 0x3ff
      is_deleted:
        value: len_raw == 0x3ff
        doc: The tag has been deleted; it has no data.
      len_data:
        value: 'is_deleted ? 0 : len_raw'
      is_crc:
        value: type.to_i & 0x780 == 0x500
      next_xor:
        value: 'is_crc ? tag ^ ((chunk & 1) * 0x8000_0000) : tag'
  name:
    seq:
      - id: value
        size-eos: true
        type: str
        doc: File name, or "littlefs" for the superblock entry.
  metadata_pair_ptr:
    seq:
      - id: block_a
        type: u4
      - id: block_b
        type: u4
    instances:
      pair:
        type: metadata_pair(block_a, block_b)
  ctz_struct:
    seq:
      - id: head_block
        type: u4
        doc: Block number of the last block of the file's CTZ skip-list.
      - id: len_file
        -orig-id: size
        type: u4
  crc:
    seq:
      - id: crc
        type: u4
        doc: |
          CRC-32 of the commit, including this tag. The rest of the data is
          padding to the next program block boundary.
  fcrc:
    seq:
      - id: len_fcrc
        type: u4
        doc: Number of bytes after this commit's CRC padding covered by `fcrc`.
      - id: fcrc
        type: u4
        doc: CRC-32 of these bytes in their erased state.
  move_state:
    seq:
      - id: move_tag
        type: u4
      - id: pair
        type: metadata_pair_ptr
        doc: Metadata pair containing the file being moved.
    instances:
      is_unsynced:
        value: move_tag & 0x8000_0000 != 0
        doc: The threaded linked list of metadata pairs may be out of sync.
      move_type:
        value: (move_tag >> 20) & 0x7ff
        doc: 0 - no move in progress, 0x4FF - the source file must be deleted.
      move_id:
        value: (move_tag >> 10) & 0x3ff
enums:
  tag_type:
    0x001: reg
    0x002: dir
    0x0ff: superblock
    0x200: dir_struct
    0x201: inline_struct
    0x202: ctz_struct
    0x401: create
    0x4ff: delete
    0x500: crc
    0x501: crc_flipped
    0x5ff: fcrc
    0x600: soft_tail
    0x601: hard_tail
    0x7ff: move_state
