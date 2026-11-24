meta:
  id: hdf5
  title: Hierarchical Data Format version 5 (HDF5) superblock
  application:
    - HDF5 library
    - h5py
    - MATLAB (v7.3 MAT-files)
    - NetCDF-4
  file-extension:
    - h5
    - hdf5
    - he5
  license: CC0-1.0
  ks-version: '0.11'
  endian: le
doc: |
  HDF5 is a self-describing container for large scientific datasets, developed
  by The HDF Group. All metadata is little-endian.

  This spec covers only the file metadata at "level 0" of the format
  specification: the superblock (versions 0 to 3) with the root group symbol
  table entry (versions 0 and 1) and the optional driver information block.
  The object headers, B-trees, heaps and datasets reachable from the root group
  are not parsed.

  The superblock is expected at offset 0. HDF5 also allows it at offsets 512,
  1024, 2048, ... after a "user block"; such files can be parsed by passing a
  substream starting at the superblock. Addresses in the superblock (except
  `ofs_base` and `ofs_end_of_file`) are relative to the base address, normally
  the offset of the superblock. Only 8-byte offsets and lengths, which are what
  the HDF5 library writes by default, are supported in the address fields;
  "undefined address" is all bits set.
doc-ref: https://support.hdfgroup.org/documentation/hdf5/latest/_f_m_t3.html
seq:
  - id: magic
    contents: [0x89, 0x48, 0x44, 0x46, 0x0d, 0x0a, 0x1a, 0x0a]
  - id: version
    type: u1
    valid:
      max: 3
  - id: superblock
    type:
      switch-on: version
      cases:
        0: superblock_v0_v1
        1: superblock_v0_v1
        2: superblock_v2_v3
        3: superblock_v2_v3
instances:
  driver_info:
    pos: superblock.as<superblock_v0_v1>.ofs_driver_info + superblock.as<superblock_v0_v1>.ofs_base
    type: driver_info_block
    if: version < 2 and superblock.as<superblock_v0_v1>.ofs_driver_info != 0xffff_ffff_ffff_ffff
types:
  superblock_v0_v1:
    seq:
      - id: free_space_version
        type: u1
        doc: Version of the file's free space information; always 0.
      - id: root_group_symbol_table_entry_version
        type: u1
        doc: Always 0.
      - id: reserved1
        type: u1
      - id: shared_header_message_version
        type: u1
        doc: Always 0.
      - id: len_offsets
        type: u1
        valid: 8
        doc: Size of file addresses in bytes.
      - id: len_lengths
        type: u1
        valid: 8
        doc: Size of object sizes in bytes.
      - id: reserved2
        type: u1
      - id: group_leaf_node_k
        type: u2
      - id: group_internal_node_k
        type: u2
      - id: file_consistency_flags
        type: u4
        doc: Unused.
      - id: indexed_storage_internal_node_k
        type: u2
        if: _parent.version == 1
      - id: reserved3
        type: u2
        if: _parent.version == 1
      - id: ofs_base
        type: u8
        doc: Absolute address of the first byte of HDF5 data (the superblock).
      - id: ofs_free_space_info
        type: u8
        doc: Address of the global free-space index; always undefined.
      - id: ofs_end_of_file
        type: u8
        doc: Absolute address of the first byte past the end of all HDF5 data.
      - id: ofs_driver_info
        type: u8
        doc: Relative address of the driver information block, or undefined.
      - id: root_group_symbol_table_entry
        type: symbol_table_entry
  superblock_v2_v3:
    seq:
      - id: len_offsets
        type: u1
        valid: 8
      - id: len_lengths
        type: u1
        valid: 8
      - id: file_consistency_flags
        type: u1
        doc: |
          Version 3 only: bit 0 - opened for write access, bit 2 - opened for
          single-writer/multiple-reader (SWMR) write access.
      - id: ofs_base
        type: u8
      - id: ofs_superblock_extension
        type: u8
        doc: Address of the superblock extension object header, or undefined.
      - id: ofs_end_of_file
        type: u8
      - id: ofs_root_group_object_header
        type: u8
      - id: checksum
        type: u4
        doc: Jenkins lookup3 checksum of the preceding superblock bytes.
  symbol_table_entry:
    seq:
      - id: ofs_link_name
        type: u8
        doc: Offset of the link name in the group's local heap.
      - id: ofs_object_header
        type: u8
      - id: cache_type
        type: u4
        enum: cache_type
      - id: reserved
        type: u4
      - id: scratch_pad
        size: 16
        type:
          switch-on: cache_type
          cases:
            cache_type::group: scratch_pad_group
            cache_type::symbolic_link: scratch_pad_symbolic_link
  scratch_pad_group:
    seq:
      - id: ofs_btree
        type: u8
        doc: Address of the root of the group's B-tree.
      - id: ofs_name_heap
        type: u8
        doc: Address of the group's local heap.
  scratch_pad_symbolic_link:
    seq:
      - id: ofs_link_value
        type: u4
        doc: Offset of the link value in the local heap.
  driver_info_block:
    seq:
      - id: version
        type: u1
      - id: reserved
        size: 3
      - id: len_driver_info
        type: u4
      - id: driver_id
        size: 8
        type: str
        encoding: ASCII
        doc: |
          `NCSA` followed by the first four characters of the driver name
          (e.g. `NCSAmult`, `NCSAfami`) for the predefined drivers.
      - id: driver_info
        size: len_driver_info
enums:
  cache_type:
    0: none
    1: group
    2: symbolic_link
