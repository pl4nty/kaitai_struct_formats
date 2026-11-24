meta:
  id: exfat
  title: Extended File Allocation Table (exFAT) file system
  application: Microsoft Windows
  xref:
    justsolve: exFAT
  tags:
    - filesystem
    - windows
  license: CC0-1.0
  ks-version: '0.9'
  imports:
    - /common/dos_datetime
  endian: le
doc: |
  exFAT is a file system designed by Microsoft for flash media (SD cards with
  more than 32 GiB, USB flash drives). A volume consists of the main boot
  region (boot sector, 8 extended boot sectors, OEM parameters, boot checksum),
  a backup boot region, one or two File Allocation Tables, and the cluster
  heap, which holds the allocation bitmap, the up-case table, the root
  directory and all files and directories.

  This spec covers the main boot region, the backup boot sector, the
  (first) FAT, and the root directory, which is read by following its cluster
  chain in the FAT. All directory entry types defined by the specification
  are parsed (allocation bitmap, up-case table, volume label, volume GUID,
  file, stream extension, file name, vendor extension and vendor allocation);
  subdirectories and file contents are not followed, but the stream extension
  entries give their first cluster and length.
doc-ref:
  - https://learn.microsoft.com/en-us/windows/win32/fileio/exfat-specification
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/fs/exfat/exfat_raw.h
seq:
  - id: boot_sector
    type: boot_sector
instances:
  sector_size:
    value: 1 << boot_sector.bytes_per_sector_shift
  cluster_size:
    value: sector_size << boot_sector.sectors_per_cluster_shift
  main_boot_region:
    pos: 0
    size: 12 * sector_size
    type: boot_region
  backup_boot_sector:
    pos: 12 * sector_size
    type: boot_sector
  fat:
    pos: boot_sector.ofs_fat * sector_size
    size: boot_sector.len_fat * sector_size
    type: fat
    doc: The first FAT.
  root_directory:
    type: cluster_chain(boot_sector.root_directory_cluster)
    doc: Root directory, as a chain of clusters.
types:
  boot_sector:
    seq:
      - id: jump_boot
        contents: [0xeb, 0x76, 0x90]
      - id: file_system_name
        contents: 'EXFAT   '
      - id: must_be_zero
        size: 53
      - id: partition_offset
        type: u8
        doc: |
          Media-relative sector offset of the partition hosting this volume (0 if
          unknown).
      - id: len_volume
        type: u8
        doc: Size of the volume in sectors.
      - id: ofs_fat
        type: u4
        doc: Volume-relative sector offset of the first FAT.
      - id: len_fat
        type: u4
        doc: Length of each FAT in sectors.
      - id: ofs_cluster_heap
        type: u4
        doc: Volume-relative sector offset of the cluster heap.
      - id: num_clusters
        type: u4
      - id: root_directory_cluster
        type: u4
      - id: volume_serial_number
        type: u4
      - id: file_system_revision_minor
        type: u1
      - id: file_system_revision_major
        type: u1
      - id: volume_flags
        type: volume_flags
      - id: bytes_per_sector_shift
        type: u1
        valid:
          min: 9
          max: 12
      - id: sectors_per_cluster_shift
        type: u1
      - id: num_fats
        type: u1
        valid:
          any-of: [1, 2]
      - id: drive_select
        type: u1
      - id: percent_in_use
        type: u1
        doc: Percentage of allocated clusters, or 0xff if unknown.
      - id: reserved
        size: 7
      - id: boot_code
        size: 390
      - id: boot_signature
        contents: [0x55, 0xaa]
  volume_flags:
    meta:
      bit-endian: le
    seq:
      - id: active_fat
        type: b1
        doc: 0 if the first FAT and allocation bitmap are active, 1 for the second ones.
      - id: volume_dirty
        type: b1
      - id: media_failure
        type: b1
      - id: clear_to_zero
        type: b1
      - id: reserved
        type: b12
  boot_region:
    seq:
      - id: boot_sector
        size: _root.sector_size
      - id: extended_boot_sectors
        size: _root.sector_size
        type: extended_boot_sector
        repeat: expr
        repeat-expr: 8
      - id: oem_parameters
        size: _root.sector_size
      - id: reserved
        size: _root.sector_size
      - id: boot_checksum
        size: _root.sector_size
        type: boot_checksum_sector
  extended_boot_sector:
    seq:
      - id: boot_code
        size: _io.size - 4
      - id: extended_boot_signature
        type: u4
        doc: 0xAA550000 if the sector is an extended boot sector.
  boot_checksum_sector:
    seq:
      - id: checksums
        type: u4
        repeat: eos
        doc: The checksum of the preceding 11 sectors, repeated throughout the sector.
  fat:
    seq:
      - id: media_type
        type: u4
        doc: 0xFFFFFFF8 for the media descriptor.
      - id: reserved
        type: u4
      - id: entries
        type: u4
        repeat: expr
        repeat-expr: _root.boot_sector.num_clusters
        doc: |
          Entry for each cluster of the cluster heap, starting at cluster 2:
          the next cluster of the chain, 0xFFFFFFF7 for a bad cluster, or
          0xFFFFFFFF for the end of a chain. Only meaningful for allocations
          whose `no_fat_chain` flag is clear.
  cluster_chain:
    params:
      - id: cluster
        type: u4
    instances:
      data:
        io: _root._io
        pos: _root.boot_sector.ofs_cluster_heap * _root.sector_size + (cluster - 2) * _root.cluster_size
        size: _root.cluster_size
        type: directory_cluster
      fat_entry:
        value: _root.fat.entries[cluster - 2]
      has_next:
        value: fat_entry >= 2 and fat_entry < _root.boot_sector.num_clusters + 2
      next:
        type: cluster_chain(fat_entry)
        if: has_next
  directory_cluster:
    seq:
      - id: entries
        type: directory_entry
        repeat: until
        repeat-until: _.entry_type == 0 or _io.eof
  directory_entry:
    seq:
      - id: entry_type
        type: u1
        doc: |
          Bits 0-4 are the type code, bit 5 the type importance (benign), bit
          6 the type category (secondary), bit 7 the in-use flag. 0 marks the
          end of the directory; values 0x01-0x7F are unused (deleted) entries.
      - id: body
        size: 31
        type:
          switch-on: entry_type
          cases:
            0x81: allocation_bitmap_entry
            0x82: upcase_table_entry
            0x83: volume_label_entry
            0x85: file_entry
            0xa0: volume_guid_entry
            0xc0: stream_extension_entry
            0xc1: file_name_entry
            0xe0: vendor_extension_entry
            0xe1: vendor_allocation_entry
    instances:
      is_in_use:
        value: entry_type & 0x80 != 0
      is_secondary:
        value: entry_type & 0x40 != 0
      is_benign:
        value: entry_type & 0x20 != 0
      type_code:
        value: entry_type & 0x1f
  general_flags:
    meta:
      bit-endian: le
    seq:
      - id: allocation_possible
        type: b1
      - id: no_fat_chain
        type: b1
        doc: |
          If set, the allocation is one contiguous run of clusters and its FAT entries are
          invalid.
      - id: custom_defined
        type: b6
  allocation_bitmap_entry:
    seq:
      - id: is_second_bitmap
        type: u1
        doc: Bit 0 of BitmapFlags; 0 for the first allocation bitmap, 1 for the second.
      - id: reserved
        size: 18
      - id: first_cluster
        type: u4
      - id: len_data
        type: u8
  upcase_table_entry:
    seq:
      - id: reserved1
        size: 3
      - id: table_checksum
        type: u4
      - id: reserved2
        size: 12
      - id: first_cluster
        type: u4
      - id: len_data
        type: u8
  volume_label_entry:
    seq:
      - id: num_chars
        type: u1
      - id: volume_label
        size: 22
        type: str
        encoding: UTF-16LE
        doc: Use only the first `num_chars` characters.
      - id: reserved
        size: 8
  file_entry:
    doc: Primary entry of a file or directory entry set.
    seq:
      - id: num_secondary_entries
        type: u1
        doc: |
          Number of secondary entries (stream extension, file names and others) following
          this entry.
      - id: set_checksum
        type: u2
      - id: attributes
        type: file_attributes
      - id: reserved1
        type: u2
      - id: create_timestamp
        type: dos_datetime
      - id: last_modified_timestamp
        type: dos_datetime
      - id: last_accessed_timestamp
        type: dos_datetime
      - id: create_10ms_increment
        type: u1
        doc: Additional time in units of 10 ms (0-199) to add to `create_timestamp`.
      - id: last_modified_10ms_increment
        type: u1
      - id: create_utc_offset
        type: utc_offset
      - id: last_modified_utc_offset
        type: utc_offset
      - id: last_accessed_utc_offset
        type: utc_offset
      - id: reserved2
        size: 7
  file_attributes:
    meta:
      bit-endian: le
    seq:
      - id: read_only
        type: b1
      - id: hidden
        type: b1
      - id: system
        type: b1
      - id: reserved1
        type: b1
      - id: directory
        type: b1
      - id: archive
        type: b1
      - id: reserved2
        type: b10
  utc_offset:
    meta:
      bit-endian: le
    seq:
      - id: offset_raw
        type: b7
      - id: offset_valid
        type: b1
    instances:
      offset_from_utc:
        value: 'offset_raw >= 64 ? offset_raw - 128 : offset_raw'
        doc: Offset of local time from UTC, in 15-minute intervals.
  volume_guid_entry:
    seq:
      - id: num_secondary_entries
        type: u1
      - id: set_checksum
        type: u2
      - id: general_primary_flags
        type: u2
      - id: volume_guid
        size: 16
      - id: reserved
        size: 10
  stream_extension_entry:
    doc: |
      Secondary entry describing the data of a file or directory: its name
      length and hash, and its allocation in the cluster heap.
    seq:
      - id: flags
        type: general_flags
      - id: reserved1
        type: u1
      - id: len_name
        type: u1
        doc: |
          Length of the name in UTF-16 code units, spread over the following file name
          entries.
      - id: name_hash
        type: u2
      - id: reserved2
        type: u2
      - id: valid_data_length
        type: u8
        doc: How far into the data user data has been written.
      - id: reserved3
        type: u4
      - id: first_cluster
        type: u4
      - id: len_data
        type: u8
  file_name_entry:
    seq:
      - id: flags
        type: general_flags
      - id: file_name
        size: 30
        type: str
        encoding: UTF-16LE
        doc: |
          Up to 15 characters of the name; the stream extension entry gives the total
          length.
  vendor_extension_entry:
    seq:
      - id: flags
        type: general_flags
      - id: vendor_guid
        size: 16
      - id: vendor_defined
        size: 14
  vendor_allocation_entry:
    seq:
      - id: flags
        type: general_flags
      - id: vendor_guid
        size: 16
      - id: vendor_defined
        size: 2
      - id: first_cluster
        type: u4
      - id: len_data
        type: u8
