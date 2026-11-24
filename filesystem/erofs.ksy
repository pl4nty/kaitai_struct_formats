meta:
  id: erofs
  title: EROFS (Enhanced Read-Only File System) image
  application: Linux kernel
  file-extension:
    - erofs
    - img
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  EROFS is a read-only Linux filesystem (originally from Huawei, used for
  Android system partitions and container images). The superblock lives
  at byte offset 1024. Inodes are 32-byte (compact) or 64-byte
  (extended) records located at `meta_blkaddr * block_size + 32 * nid`;
  directories are lists of blocks, each holding a sorted array of
  12-byte dirents followed by the names.

  Coverage: the superblock; inodes addressed by nid (both layouts, with
  the inline xattr area kept raw); uncompressed "flat" data (datalayout
  0 and 2, including the inline tail) for regular files, symlinks and
  directories; and directory blocks with their entries, so that the tree
  can be walked from `root_inode` through `dirents[].inode`.
  Not covered: compressed inodes (datalayout 1 and 3), chunk-based
  inodes (4), shared/long-prefix xattrs, extra devices, the metabox
  (inodes whose dirent nid has bit 63 set), and directory block sizes
  other than the filesystem block size.
doc-ref:
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/fs/erofs/erofs_fs.h
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/fs/erofs/inode.c
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/Documentation/filesystems/erofs.rst
instances:
  superblock:
    pos: 1024
    type: superblock
  block_size:
    value: 1 << superblock.blkszbits
  is_48bit:
    value: superblock.feature_incompat & 0x80 != 0
    doc: EROFS_FEATURE_INCOMPAT_48BIT
  root_nid:
    value: 'is_48bit ? superblock.rootnid_8b : superblock.rootnid_2b_or_blocks_hi'
  root_inode:
    pos: 0
    type: inode(root_nid)
types:
  superblock:
    -orig-id: erofs_super_block
    seq:
      - id: magic
        contents: [0xe2, 0xe1, 0xf5, 0xe0]
        doc: EROFS_SUPER_MAGIC_V1 (0xE0F5E1E2).
      - id: checksum
        type: u4
        doc: CRC32C of the superblock block, if feature_compat has SB_CHKSUM.
      - id: feature_compat
        type: u4
      - id: blkszbits
        type: u1
        doc: log2 of the filesystem block size.
      - id: sb_extslots
        type: u1
        doc: Superblock size is 128 + 16 * sb_extslots.
      - id: rootnid_2b_or_blocks_hi
        -orig-id: rb
        type: u2
        doc: nid of the root directory, or (with 48BIT) high 16 bits of the block count.
      - id: inos
        type: u8
        doc: Total number of valid inodes.
      - id: epoch
        type: u8
        doc: Base seconds for compact inode timestamps.
      - id: fixed_nsec
        type: u4
      - id: blocks_lo
        type: u4
      - id: meta_blkaddr
        type: u4
        doc: Start block of the inode metadata area.
      - id: xattr_blkaddr
        type: u4
        doc: Start block of the shared xattr area.
      - id: uuid
        size: 16
      - id: volume_name
        size: 16
        type: strz
        encoding: UTF-8
      - id: feature_incompat
        type: u4
      - id: available_compr_algs_or_lz4_max_distance
        -orig-id: u1
        type: u2
      - id: extra_devices
        type: u2
      - id: devt_slotoff
        type: u2
      - id: dirblkbits
        type: u1
      - id: xattr_prefix_count
        type: u1
      - id: xattr_prefix_start
        type: u4
      - id: packed_nid
        type: u8
      - id: xattr_filter_reserved
        type: u1
      - id: ishare_xattr_prefix_id
        type: u1
      - id: reserved
        size: 2
      - id: build_time
        type: u4
        doc: Seconds added to `epoch` for the mkfs time.
      - id: rootnid_8b
        type: u8
        doc: nid of the root directory with 48BIT.
      - id: reserved2
        type: u8
      - id: metabox_nid
        type: u8
      - id: reserved3
        type: u8
  inode:
    params:
      - id: nid
        type: u8
    instances:
      ofs_inode:
        value: _root.superblock.meta_blkaddr * _root.block_size + 32 * nid
      i_format:
        pos: ofs_inode
        type: u2
      is_extended:
        value: i_format & 1 != 0
      datalayout:
        value: (i_format >> 1) & 7
        enum: datalayouts
      header:
        pos: ofs_inode
        type:
          switch-on: is_extended
          cases:
            false: inode_compact
            true: inode_extended
      len_inode:
        value: 'is_extended ? 64 : 32'
      xattr_icount:
        pos: ofs_inode + 2
        type: u2
        doc: Same position in both inode layouts.
      mode:
        pos: ofs_inode + 4
        type: u2
        doc: Same position in both inode layouts.
      nb:
        pos: ofs_inode + 6
        type: u2
        doc: Same position in both inode layouts.
      file_type:
        value: (mode >> 12) & 0xf
        enum: file_types
      size:
        value: 'is_extended ? header.as<inode_extended>.size : header.as<inode_compact>.size'
      startblk_lo:
        value: 'is_extended ? header.as<inode_extended>.u : header.as<inode_compact>.u'
        doc: For flat inodes, the starting block number of the data.
      is_nlink_1:
        -orig-id: EROFS_I_NLINK_1_BIT
        value: (i_format >> 4) & 1 != 0
        doc: |
          In a compact non-directory inode, the link count is 1 and `nb` holds
          the high 16 bits of the start block / block count instead. (In a
          directory the same bit means that the `.` dirent is omitted.)
      has_nb_hi:
        value: is_extended or (file_type != file_types::directory and is_nlink_1)
        doc: Whether `nb` holds the high bits of the start block / block count.
      nlink:
        value: 'is_extended ? header.as<inode_extended>.nlink : has_nb_hi ? 1 : nb'
      startblk:
        value: 'has_nb_hi ? (nb.as<u8> << 32) | startblk_lo : startblk_lo'
      len_xattr_ibody:
        value: 'xattr_icount == 0 ? 0 : 12 + 4 * (xattr_icount - 1)'
      xattr_ibody:
        pos: ofs_inode + len_inode
        size: len_xattr_ibody
        if: len_xattr_ibody != 0
        doc: Inline xattr area (header, shared xattr ids, inline entries), not parsed.
      is_flat:
        value: datalayout == datalayouts::flat_plain or datalayout == datalayouts::flat_inline
      num_blocks:
        value: |
          datalayout == datalayouts::flat_inline
            ? size / _root.block_size
            : (size + _root.block_size - 1) / _root.block_size
        doc: Number of data blocks stored at `startblk` (the inline tail is not counted).
      ofs_tail_inline:
        value: ofs_inode + len_inode + len_xattr_ibody
      len_tail_inline:
        value: 'datalayout == datalayouts::flat_inline ? size % _root.block_size : 0'
      data_blocks:
        pos: startblk * _root.block_size
        size: '(num_blocks * _root.block_size > size ? size : num_blocks * _root.block_size)'
        if: is_flat and file_type != file_types::directory
        doc: Flat data stored in blocks; for `flat_inline` followed by `data_tail_inline`.
      data_tail_inline:
        pos: ofs_tail_inline
        size: len_tail_inline
        if: is_flat and file_type != file_types::directory and len_tail_inline != 0
      dir_blocks:
        pos: startblk * _root.block_size
        size: '(_index + 1) * _root.block_size > size ? size - _index * _root.block_size : _root.block_size'
        type: dir_block
        repeat: expr
        repeat-expr: num_blocks
        if: is_flat and file_type == file_types::directory
      dir_tail_inline:
        pos: ofs_tail_inline
        size: len_tail_inline
        type: dir_block
        if: is_flat and file_type == file_types::directory and len_tail_inline != 0
  inode_compact:
    -orig-id: erofs_inode_compact
    seq:
      - id: format
        -orig-id: i_format
        type: u2
      - id: xattr_icount
        -orig-id: i_xattr_icount
        type: u2
      - id: mode
        -orig-id: i_mode
        type: u2
      - id: nb
        -orig-id: i_nb
        type: u2
        doc: |
          nlink, or (in non-directory inodes with EROFS_I_NLINK_1_BIT set) the
          high 16 bits of the start block / block count.
      - id: size
        -orig-id: i_size
        type: u4
      - id: mtime
        -orig-id: i_mtime
        type: u4
        doc: Seconds relative to the superblock `epoch`.
      - id: u
        -orig-id: i_u
        type: u4
        doc: Start block (flat), block count (compressed), rdev (device) or chunk info.
      - id: ino
        -orig-id: i_ino
        type: u4
      - id: uid
        -orig-id: i_uid
        type: u2
      - id: gid
        -orig-id: i_gid
        type: u2
      - id: reserved
        -orig-id: i_reserved
        type: u4
  inode_extended:
    -orig-id: erofs_inode_extended
    seq:
      - id: format
        -orig-id: i_format
        type: u2
      - id: xattr_icount
        -orig-id: i_xattr_icount
        type: u2
      - id: mode
        -orig-id: i_mode
        type: u2
      - id: nb
        -orig-id: i_nb
        type: u2
        doc: High 16 bits of the start block / block count.
      - id: size
        -orig-id: i_size
        type: u8
      - id: u
        -orig-id: i_u
        type: u4
      - id: ino
        -orig-id: i_ino
        type: u4
      - id: uid
        -orig-id: i_uid
        type: u4
      - id: gid
        -orig-id: i_gid
        type: u4
      - id: mtime
        -orig-id: i_mtime
        type: u8
      - id: mtime_nsec
        -orig-id: i_mtime_nsec
        type: u4
      - id: nlink
        -orig-id: i_nlink
        type: u4
      - id: reserved2
        -orig-id: i_reserved2
        size: 16
  dir_block:
    doc: |
      Directory block: `num_dirents` dirents, then the names; the first
      dirent's name offset also gives the number of dirents.
    seq:
      - id: dirents
        type: dirent(_index)
        repeat: expr
        repeat-expr: num_dirents
    instances:
      ofs_first_name:
        pos: 8
        type: u2
        doc: nameoff of the first dirent.
      num_dirents:
        value: ofs_first_name / 12
  dirent:
    -orig-id: erofs_dirent
    params:
      - id: idx
        type: s4
    seq:
      - id: nid_raw
        -orig-id: nid
        type: u8
      - id: ofs_name
        -orig-id: nameoff
        type: u2
      - id: file_type
        type: u1
        enum: dirent_file_types
      - id: reserved
        type: u1
    instances:
      nid:
        value: nid_raw & 0x7fff_ffff_ffff_ffff
      in_metabox:
        value: nid_raw >> 63 != 0
      name:
        pos: ofs_name
        size: |
          idx + 1 < _parent.dirents.size
            ? _parent.dirents[idx + 1].ofs_name - ofs_name
            : _io.size - ofs_name
        type: strz
        encoding: UTF-8
        doc: The last name of a block may be followed by NUL padding.
      inode:
        io: _root._io
        pos: 0
        type: inode(nid)
        if: not in_metabox
enums:
  datalayouts:
    0: flat_plain
    1: compressed_full
    2: flat_inline
    3: compressed_compact
    4: chunk_based
  file_types:
    0x1: fifo
    0x2: char_device
    0x4: directory
    0x6: block_device
    0x8: regular
    0xa: symlink
    0xc: socket
  dirent_file_types:
    0: unknown
    1: regular
    2: directory
    3: char_device
    4: block_device
    5: fifo
    6: socket
    7: symlink
