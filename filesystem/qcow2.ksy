meta:
  id: qcow2
  title: QEMU Copy-On-Write disk image, version 2/3
  application: QEMU
  file-extension:
    - qcow2
    - qcow
  xref:
    mime: application/x-qemu-disk
  tags:
    - filesystem
  license: CC0-1.0
  ks-version: '0.9'
  encoding: UTF-8
  endian: be
doc: |
  qcow2 is the native virtual disk image format of QEMU. An image is split
  into host clusters of `1 << cluster_bits` bytes; guest clusters are mapped
  to host clusters through a two-level table (L1 table -> L2 tables), and
  allocation is tracked by a two-level reference count structure (refcount
  table -> refcount blocks). Internal snapshots each keep their own L1 table.

  This spec covers the image header (versions 2 and 3, including the optional
  additional fields), the header extensions (backing file format, feature
  name table, bitmaps extension, full disk encryption header pointer,
  external data file name), the backing file name, the snapshot table, the
  active L1 table with its L2 tables, the refcount table and the bitmap
  directory. Guest data clusters (possibly compressed or encrypted),
  refcount block contents and bitmap tables are not decoded; the
  `l2_entry` type exposes the host offsets needed to locate them.

  Mapping a guest offset to a host offset (without extended L2 entries):

  ```
  l2_entries = cluster_size / 8
  l2_index = (offset / cluster_size) % l2_entries
  l1_index = (offset / cluster_size) / l2_entries
  host_offset = l1_table[l1_index].l2_table.entries[l2_index].host_cluster_offset
                + offset % cluster_size
  ```

  Test images can be created with `qemu-img create -f qcow2 <file> <size>`.
doc-ref: https://github.com/qemu/qemu/blob/master/docs/interop/qcow2.rst
seq:
  - id: magic
    contents: ["QFI", 0xfb]
  - id: version
    type: u4
    valid:
      min: 2
    doc: Version number (valid values are 2 and 3)
  - id: ofs_backing_file_name
    -orig-id: backing_file_offset
    type: u8
    doc: |
      Offset into the image file at which the backing file name is stored.
      0 if the image doesn't have a backing file.
  - id: len_backing_file_name
    -orig-id: backing_file_size
    type: u4
    doc: |
      Length of the backing file name in bytes (at most 1023). Undefined if
      the image doesn't have a backing file.
  - id: cluster_bits
    type: u4
    valid:
      min: 9
    doc: Number of bits used for addressing an offset within a cluster.
  - id: size
    type: u8
    doc: Virtual disk size in bytes.
  - id: crypt_method
    type: u4
    enum: crypt_methods
  - id: num_l1_table
    -orig-id: l1_size
    type: u4
    doc: Number of entries in the active L1 table.
  - id: ofs_l1_table
    -orig-id: l1_table_offset
    type: u8
    doc: Offset of the active L1 table. Aligned to a cluster boundary.
  - id: ofs_refcount_table
    -orig-id: refcount_table_offset
    type: u8
    doc: Offset of the refcount table. Aligned to a cluster boundary.
  - id: num_refcount_table_clusters
    -orig-id: refcount_table_clusters
    type: u4
    doc: Number of clusters that the refcount table occupies.
  - id: num_snapshots
    -orig-id: nb_snapshots
    type: u4
  - id: ofs_snapshots
    -orig-id: snapshots_offset
    type: u8
    doc: Offset of the snapshot table. Aligned to a cluster boundary.
  - id: v3_header
    type: v3_header
    if: version >= 3
  - id: header_extensions
    size: len_header_extensions
    type: header_extension_area
    doc: |
      Header extensions directly following the header. This area is limited
      to the first cluster (and ends where the backing file name starts, if
      that name is stored within the first cluster).
instances:
  cluster_size:
    value: 1 << cluster_bits
  len_header:
    value: 'version >= 3 ? v3_header.len_header : 72'
    doc: Length of the header structure in bytes (always 72 for version 2).
  refcount_order:
    value: 'version >= 3 ? v3_header.refcount_order : 4'
  refcount_bits:
    value: 1 << refcount_order
    doc: Width of a refcount block entry in bits.
  has_extended_l2_entries:
    value: 'version >= 3 ? v3_header.incompatible_features.extended_l2_entries : false'
  compression_type:
    value: |
      version >= 3 and v3_header.len_header > 104
        ? v3_header.additional_fields.compression_type.to_i
        : 0
    enum: compression_types
  len_header_extensions:
    value: |
      (ofs_backing_file_name > len_header and ofs_backing_file_name < cluster_size
        ? ofs_backing_file_name
        : cluster_size) - len_header
  backing_file_name:
    pos: ofs_backing_file_name
    size: len_backing_file_name
    type: str
    if: ofs_backing_file_name != 0
    doc: Backing file name (not null-terminated).
  l1_table:
    pos: ofs_l1_table
    type: l1_entry
    repeat: expr
    repeat-expr: num_l1_table
    doc: The active L1 table.
  refcount_table:
    pos: ofs_refcount_table
    type: u8
    repeat: expr
    repeat-expr: num_refcount_table_clusters * cluster_size / 8
    doc: |
      Refcount table. Bits 9-63 of each entry are the offset of a refcount
      block (one cluster of `refcount_bits` wide entries), bits 0-8 are
      reserved. 0 means that the refcount block has not been allocated.
  snapshots:
    pos: ofs_snapshots
    type: snapshot
    repeat: expr
    repeat-expr: num_snapshots
    if: num_snapshots != 0
types:
  v3_header:
    seq:
      - id: incompatible_features
        type: incompatible_features
        doc: |
          An implementation must fail to open an image if an unknown bit is
          set.
      - id: compatible_features
        type: compatible_features
        doc: An implementation can safely ignore any unknown bits that are set.
      - id: autoclear_features
        type: autoclear_features
        doc: |
          An implementation may only write to an image with unknown auto-clear
          features if it clears the respective bits from this field first.
      - id: refcount_order
        type: u4
        valid:
          max: 6
        doc: refcount_bits = 1 << refcount_order
      - id: len_header
        -orig-id: header_length
        type: u4
        valid:
          min: 104
        doc: |
          Length of the header structure in bytes. At least 104 and a
          multiple of 8.
      - id: additional_fields
        size: len_header - 104
        type: additional_fields
        doc: |
          Optional additional fields and padding. A field is absent when
          `len_header` is less than or equal to the field's offset; absent
          fields behave as if they were 0.
  incompatible_features:
    seq:
      - id: reserved
        type: b59
      - id: extended_l2_entries
        type: b1
        doc: L2 table entries use the extended 128-bit format with subclusters.
      - id: compression_type
        type: b1
        doc: A non-default compression type (`compression_type` field) is used.
      - id: external_data_file
        type: b1
        doc: Guest clusters are stored in an external data file.
      - id: corrupt
        type: b1
        doc: Any data structure may be corrupt; the image must not be written to.
      - id: dirty
        type: b1
        doc: Refcounts may be inconsistent.
  compatible_features:
    seq:
      - id: reserved
        type: b63
      - id: lazy_refcounts
        type: b1
  autoclear_features:
    seq:
      - id: reserved
        type: b62
      - id: raw_external_data
        type: b1
        doc: The external data file can be read as a consistent standalone raw image.
      - id: bitmaps
        type: b1
        doc: The bitmaps extension data is consistent.
  additional_fields:
    seq:
      - id: compression_type
        type: u1
        enum: compression_types
        if: not _io.eof
  header_extension_area:
    seq:
      - id: extensions
        type: header_extension
        repeat: until
        repeat-until: _.type == header_extension_type::end or _io.eof
  header_extension:
    seq:
      - id: type
        type: u4
        enum: header_extension_type
      - id: len_data
        type: u4
      - id: data
        size: len_data
        type:
          switch-on: type
          cases:
            header_extension_type::backing_file_format: string_extension
            header_extension_type::external_data_file: string_extension
            header_extension_type::feature_name_table: feature_name_table
            header_extension_type::bitmaps: bitmaps_extension
            header_extension_type::full_disk_encryption: full_disk_encryption_header_pointer
      - id: padding
        size: (8 - len_data % 8) % 8
        doc: Padding to the next multiple of 8.
  string_extension:
    doc: A single string, not null-terminated, occupying the whole extension data.
    seq:
      - id: value
        size-eos: true
        type: str
  feature_name_table:
    seq:
      - id: entries
        type: feature_name
        repeat: eos
  feature_name:
    seq:
      - id: type
        type: u1
        enum: feature_types
      - id: bit_number
        type: u1
        doc: Bit number within the selected feature bitmap (0-63).
      - id: name
        size: 46
        type: strz
        doc: Feature name (padded with zeros, not terminated if full length).
  bitmaps_extension:
    seq:
      - id: num_bitmaps
        -orig-id: nb_bitmaps
        type: u4
      - id: reserved
        size: 4
      - id: len_bitmap_directory
        -orig-id: bitmap_directory_size
        type: u8
      - id: ofs_bitmap_directory
        -orig-id: bitmap_directory_offset
        type: u8
    instances:
      bitmap_directory:
        io: _root._io
        pos: ofs_bitmap_directory
        size: len_bitmap_directory
        type: bitmap_directory
  bitmap_directory:
    seq:
      - id: entries
        type: bitmap_directory_entry
        repeat: expr
        repeat-expr: _parent.num_bitmaps
  bitmap_directory_entry:
    seq:
      - id: ofs_bitmap_table
        -orig-id: bitmap_table_offset
        type: u8
      - id: num_bitmap_table_entries
        -orig-id: bitmap_table_size
        type: u4
      - id: flags
        type: bitmap_flags
      - id: type
        type: u1
        enum: bitmap_types
      - id: granularity_bits
        type: u1
        doc: Granularity (bytes of the image per bitmap bit) is 1 << granularity_bits.
      - id: len_name
        -orig-id: name_size
        type: u2
      - id: len_extra_data
        -orig-id: extra_data_size
        type: u4
      - id: extra_data
        size: len_extra_data
      - id: name
        size: len_name
        type: str
      - id: padding
        size: (8 - (24 + len_extra_data + len_name) % 8) % 8
        doc: Padding to the next multiple of 8.
  bitmap_flags:
    seq:
      - id: reserved
        type: b29
      - id: extra_data_compatible
        type: b1
      - id: is_auto
        type: b1
        doc: The bitmap must reflect all changes of the virtual disk.
      - id: in_use
        type: b1
        doc: The bitmap was not saved correctly and may be inconsistent.
  full_disk_encryption_header_pointer:
    seq:
      - id: ofs_encryption_header
        type: u8
        doc: Offset of the encryption (LUKS) header. Aligned to a cluster boundary.
      - id: len_encryption_header
        type: u8
  l1_entry:
    seq:
      - id: is_refcount_one
        type: b1
        doc: |
          1 if the refcount of the L2 table is exactly one (only accurate in
          the active L1 table).
      - id: reserved1
        type: b7
      - id: l2_table_offset_bits
        type: b47
        doc: Bits 9-55 of the L2 table offset.
      - id: reserved2
        type: b9
    instances:
      ofs_l2_table:
        value: (l2_table_offset_bits << 9).as<u8>
        doc: Offset of the L2 table; 0 if the table and all its clusters are unallocated.
      l2_table:
        io: _root._io
        pos: ofs_l2_table
        size: _root.cluster_size
        type: l2_table
        if: ofs_l2_table != 0
  l2_table:
    seq:
      - id: entries
        type: l2_entry
        repeat: eos
  l2_entry:
    seq:
      - id: is_refcount_one
        type: b1
        doc: |
          1 for standard clusters whose refcount is exactly one (only accurate
          in L2 tables reachable from the active L1 table).
      - id: is_compressed
        type: b1
      - id: descriptor
        type: b62
        doc: Cluster descriptor; its layout depends on `is_compressed`.
      - id: subcluster_bitmap
        type: u8
        if: _root.has_extended_l2_entries
        doc: |
          Extended L2 entries only. For standard clusters bits 0-31 are the
          allocation status and bits 32-63 the "reads as zeros" status of
          the 32 subclusters.
    instances:
      reads_as_zeros:
        value: not is_compressed and (descriptor & 1) == 1
        doc: Standard clusters only (version 3, no extended L2 entries).
      host_cluster_offset:
        value: (descriptor & 0x00ff_ffff_ffff_fe00).as<u8>
        if: not is_compressed
        doc: |
          Host cluster offset of a standard cluster. If 0 and
          `is_refcount_one` is clear, the cluster is unallocated.
      compressed_offset_bits:
        value: 62 - (_root.cluster_bits - 8)
        if: is_compressed
      compressed_host_offset:
        value: (descriptor & (0x3fff_ffff_ffff_ffff >> (_root.cluster_bits - 8))).as<u8>
        if: is_compressed
        doc: Host offset of the compressed data (usually not aligned).
      compressed_num_additional_sectors:
        value: (descriptor >> compressed_offset_bits).as<u8>
        if: is_compressed
        doc: |
          Number of additional 512-byte sectors used for the compressed
          data, beyond the sector containing the offset.
  snapshot:
    seq:
      - id: ofs_l1_table
        -orig-id: l1_table_offset
        type: u8
      - id: num_l1_table
        -orig-id: l1_size
        type: u4
      - id: len_id
        type: u2
      - id: len_name
        type: u2
      - id: date_sec
        type: u4
        doc: Time at which the snapshot was taken, in seconds since the Epoch.
      - id: date_nsec
        type: u4
        doc: Subsecond part of the time, in nanoseconds.
      - id: vm_clock_nsec
        type: u8
        doc: Time that the guest was running until the snapshot was taken, in nanoseconds.
      - id: len_vm_state_small
        -orig-id: vm_state_size
        type: u4
        doc: |
          Size of the VM state in bytes; ignored if `extra_data.len_vm_state`
          is present.
      - id: len_extra_data
        -orig-id: extra_data_size
        type: u4
      - id: extra_data
        size: len_extra_data
        type: snapshot_extra_data
      - id: id
        size: len_id
        type: str
        doc: Unique ID string for the snapshot.
      - id: name
        size: len_name
        type: str
      - id: padding
        size: (8 - (40 + len_extra_data + len_id + len_name) % 8) % 8
        doc: Padding to the next multiple of 8.
    instances:
      l1_table:
        pos: ofs_l1_table
        type: u8
        repeat: expr
        repeat-expr: num_l1_table
        doc: Raw L1 table entries of this snapshot (same layout as `l1_entry`).
  snapshot_extra_data:
    seq:
      - id: len_vm_state
        type: u8
        if: _io.size >= 8
      - id: disk_size
        type: u8
        if: _io.size >= 16
        doc: Virtual disk size of the snapshot in bytes.
      - id: icount
        type: s8
        if: _io.size >= 24
        doc: |
          Record/replay instruction count when the snapshot was taken; -1 if icount was
          disabled.
enums:
  crypt_methods:
    0: none
    1: aes
    2: luks
  compression_types:
    0: deflate
    1: zstd
  header_extension_type:
    0x00000000: end
    0xe2792aca: backing_file_format
    0x6803f857: feature_name_table
    0x23852875: bitmaps
    0x0537be77: full_disk_encryption
    0x44415441: external_data_file
  feature_types:
    0: incompatible
    1: compatible
    2: autoclear
  bitmap_types:
    1: dirty_tracking
