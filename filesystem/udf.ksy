meta:
  id: udf
  title: Universal Disk Format (UDF) / ECMA-167 volume
  application:
    - mkudffs
    - Linux udf driver
  file-extension:
    - udf
    - iso
    - img
  tags:
    - filesystem
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Universal Disk Format, the file system of DVDs, Blu-ray discs and many
  packet-written optical media, defined by OSTA as a profile of ECMA-167
  (3rd edition). This spec describes a partial but navigable subset:

  * the Volume Recognition Sequence (BEA01/NSR02/NSR03/TEA01 and other
    volume structure descriptors) starting at byte 32768;
  * the Anchor Volume Descriptor Pointer at sector 256;
  * the Main Volume Descriptor Sequence (primary, implementation use,
    partition, logical volume, unallocated space and terminating
    descriptors) and the Logical Volume Integrity Descriptor;
  * the File Set Descriptor and, from there, the directory tree: (Extended)
    File Entries with short or long allocation descriptors (or data
    embedded in the ICB) and File Identifier Descriptors.

  Limitations: the sector size is detected by probing for the anchor at
  sector 256 with 2048-, 512- and 4096-byte sectors; the logical block
  size is assumed to equal the sector size; logical block addresses are
  resolved against the first partition descriptor only, so virtual,
  sparable and metadata partitions (UDF 1.50+ type 2 maps, UDF 2.50+
  metadata files) are not followed, and only the first extent of a
  directory is read; descriptor CRCs
  and checksums are not verified.
doc-ref:
  - https://ecma-international.org/wp-content/uploads/ECMA-167_3rd_edition_june_1997.pdf
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/fs/udf/ecma_167.h
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/fs/udf/osta_udf.h
instances:
  sector_size:
    value: |
      _io.size >= 257 * 2048 and probe_2048.tag_ident == tag_identifier::anchor_volume_descriptor_pointer and probe_2048.tag_location == 256 ? 2048 :
      _io.size >= 257 * 512 and probe_512.tag_ident == tag_identifier::anchor_volume_descriptor_pointer and probe_512.tag_location == 256 ? 512 :
      4096
  probe_2048:
    pos: 256 * 2048
    type: tag
  probe_512:
    pos: 256 * 512
    type: tag
  volume_recognition_sequence:
    pos: 32768
    type: volume_structure_descriptor
    repeat: until
    repeat-until: |
      _.std_ident == "TEA01" or _io.eof or (
        _.std_ident != "BEA01" and _.std_ident != "NSR02" and _.std_ident != "NSR03" and
        _.std_ident != "BOOT2" and _.std_ident != "CD001" and _.std_ident != "CDW02"
      )
    doc: |
      Volume structure descriptors, one per 2048 bytes (or per sector if
      sectors are larger), up to TEA01 or the first unrecognised one. An
      NSR02 or NSR03 descriptor between BEA01 and TEA01 marks an ECMA-167
      volume.
  anchor:
    pos: 256 * sector_size
    size: sector_size
    type: descriptor
    doc: |
      Anchor Volume Descriptor Pointer (also found at the last sector, and possibly at
      last - 256).
  main_volume_descriptor_sequence:
    pos: anchor.body.as<anchor_volume_descriptor_pointer>.main_vds.location * sector_size
    size: anchor.body.as<anchor_volume_descriptor_pointer>.main_vds.length
    type: volume_descriptor_sequence
  partition_descriptor:
    value: main_volume_descriptor_sequence.partition_descriptor.body.as<partition_descriptor>
    doc: First partition descriptor of the main volume descriptor sequence.
  logical_volume_descriptor:
    value: main_volume_descriptor_sequence.logical_volume_descriptor.body.as<logical_volume_descriptor>
  partition_start:
    value: partition_descriptor.starting_location * sector_size
    doc: Byte offset of logical block 0 of the partition.
  logical_volume_integrity:
    pos: logical_volume_descriptor.integrity_sequence.location * sector_size
    size: sector_size
    type: descriptor
    if: logical_volume_descriptor.integrity_sequence.length != 0
  file_set_descriptor:
    pos: partition_start + logical_volume_descriptor.file_set_descriptor_location.location.logical_block_num * sector_size
    size: sector_size
    type: descriptor
    doc: File Set Descriptor, pointed to by the logical volume contents use field.
  root_directory:
    pos: partition_start + file_set_descriptor.body.as<file_set_descriptor>.root_directory_icb.location.logical_block_num * sector_size
    size: sector_size
    type: descriptor
    doc: File Entry of the root directory.
types:
  tag:
    doc: Descriptor tag (ECMA-167 3/7.2), 16 bytes.
    seq:
      - id: tag_ident
        type: u2
        enum: tag_identifier
      - id: descriptor_version
        type: u2
        doc: 2 for NSR02 volumes, 3 for NSR03.
      - id: tag_checksum
        type: u1
        doc: Sum modulo 256 of the tag bytes except this one.
      - id: reserved
        type: u1
      - id: tag_serial_number
        type: u2
      - id: descriptor_crc
        type: u2
        doc: CRC-ITU-T of the `descriptor_crc_length` bytes following the tag.
      - id: descriptor_crc_length
        type: u2
      - id: tag_location
        type: u4
        doc: Sector (or logical block within the partition) of this descriptor.
  volume_structure_descriptor:
    seq:
      - id: structure_type
        type: u1
      - id: std_ident
        size: 5
        type: str
        encoding: ASCII
        doc: BEA01, NSR02, NSR03, TEA01, BOOT2, CD001 (ISO 9660) or CDW02.
      - id: structure_version
        type: u1
      - id: structure_data
        size: 2041
  descriptor:
    seq:
      - id: tag
        type: tag
      - id: body
        type:
          switch-on: tag.tag_ident
          cases:
            tag_identifier::primary_volume_descriptor: primary_volume_descriptor
            tag_identifier::anchor_volume_descriptor_pointer: anchor_volume_descriptor_pointer
            tag_identifier::volume_descriptor_pointer: volume_descriptor_pointer
            tag_identifier::implementation_use_volume_descriptor: implementation_use_volume_descriptor
            tag_identifier::partition_descriptor: partition_descriptor
            tag_identifier::logical_volume_descriptor: logical_volume_descriptor
            tag_identifier::unallocated_space_descriptor: unallocated_space_descriptor
            tag_identifier::logical_volume_integrity_descriptor: logical_volume_integrity_descriptor
            tag_identifier::file_set_descriptor: file_set_descriptor
            tag_identifier::file_entry: file_entry(false)
            tag_identifier::extended_file_entry: file_entry(true)
  volume_descriptor_sequence:
    seq:
      - id: descriptors
        size: _root.sector_size
        type: descriptor
        repeat: until
        repeat-until: _.tag.tag_ident == tag_identifier::terminating_descriptor or _io.eof
    instances:
      idx_partition_descriptor:
        value: |
          descriptors.size > 0 and descriptors[0].tag.tag_ident == tag_identifier::partition_descriptor ? 0 :
          descriptors.size > 1 and descriptors[1].tag.tag_ident == tag_identifier::partition_descriptor ? 1 :
          descriptors.size > 2 and descriptors[2].tag.tag_ident == tag_identifier::partition_descriptor ? 2 :
          descriptors.size > 3 and descriptors[3].tag.tag_ident == tag_identifier::partition_descriptor ? 3 :
          descriptors.size > 4 and descriptors[4].tag.tag_ident == tag_identifier::partition_descriptor ? 4 :
          descriptors.size > 5 and descriptors[5].tag.tag_ident == tag_identifier::partition_descriptor ? 5 :
          descriptors.size > 6 and descriptors[6].tag.tag_ident == tag_identifier::partition_descriptor ? 6 :
          descriptors.size > 7 and descriptors[7].tag.tag_ident == tag_identifier::partition_descriptor ? 7 :
          descriptors.size > 8 and descriptors[8].tag.tag_ident == tag_identifier::partition_descriptor ? 8 :
          descriptors.size > 9 and descriptors[9].tag.tag_ident == tag_identifier::partition_descriptor ? 9 :
          descriptors.size > 10 and descriptors[10].tag.tag_ident == tag_identifier::partition_descriptor ? 10 :
          descriptors.size > 11 and descriptors[11].tag.tag_ident == tag_identifier::partition_descriptor ? 11 :
          descriptors.size > 12 and descriptors[12].tag.tag_ident == tag_identifier::partition_descriptor ? 12 :
          descriptors.size > 13 and descriptors[13].tag.tag_ident == tag_identifier::partition_descriptor ? 13 :
          descriptors.size > 14 and descriptors[14].tag.tag_ident == tag_identifier::partition_descriptor ? 14 :
          descriptors.size > 15 and descriptors[15].tag.tag_ident == tag_identifier::partition_descriptor ? 15 :
          -1
        doc: Index of the first partition descriptor (among the first 16 descriptors), or -1.
      idx_logical_volume_descriptor:
        value: |
          descriptors.size > 0 and descriptors[0].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 0 :
          descriptors.size > 1 and descriptors[1].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 1 :
          descriptors.size > 2 and descriptors[2].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 2 :
          descriptors.size > 3 and descriptors[3].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 3 :
          descriptors.size > 4 and descriptors[4].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 4 :
          descriptors.size > 5 and descriptors[5].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 5 :
          descriptors.size > 6 and descriptors[6].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 6 :
          descriptors.size > 7 and descriptors[7].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 7 :
          descriptors.size > 8 and descriptors[8].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 8 :
          descriptors.size > 9 and descriptors[9].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 9 :
          descriptors.size > 10 and descriptors[10].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 10 :
          descriptors.size > 11 and descriptors[11].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 11 :
          descriptors.size > 12 and descriptors[12].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 12 :
          descriptors.size > 13 and descriptors[13].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 13 :
          descriptors.size > 14 and descriptors[14].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 14 :
          descriptors.size > 15 and descriptors[15].tag.tag_ident == tag_identifier::logical_volume_descriptor ? 15 :
          -1
        doc: |
          Index of the first logical volume descriptor (among the first 16 descriptors),
          or -1.
      partition_descriptor:
        value: descriptors[idx_partition_descriptor]
        if: idx_partition_descriptor >= 0
      logical_volume_descriptor:
        value: descriptors[idx_logical_volume_descriptor]
        if: idx_logical_volume_descriptor >= 0
  extent_ad:
    seq:
      - id: length
        type: u4
        doc: Length in bytes.
      - id: location
        type: u4
        doc: Sector number.
  lb_addr:
    seq:
      - id: logical_block_num
        type: u4
      - id: partition_reference_num
        type: u2
  short_ad:
    seq:
      - id: length_and_type
        type: u4
      - id: position
        type: u4
        doc: Logical block number within the partition.
    instances:
      length:
        value: length_and_type & 0x3fff_ffff
      extent_type:
        value: length_and_type >> 30
        doc: |
          0 = recorded and allocated, 1 = allocated only, 2 = not allocated, 3 =
          continuation.
  long_ad:
    seq:
      - id: length_and_type
        type: u4
      - id: location
        type: lb_addr
      - id: implementation_use
        size: 6
    instances:
      length:
        value: length_and_type & 0x3fff_ffff
      extent_type:
        value: length_and_type >> 30
  charspec:
    seq:
      - id: character_set_type
        type: u1
        doc: 0 = CS0 (OSTA Compressed Unicode in UDF).
      - id: character_set_info
        size: 63
        type: strz
        encoding: ASCII
  dstring:
    doc: |
      Fixed-size string field (ECMA-167 1/7.2.12); the last byte holds the
      length of the used part, which starts with an OSTA CS0 compression
      ID (8 or 16).
    seq:
      - id: data
        size: _io.size - 1
      - id: len_value
        type: u1
    instances:
      value:
        pos: 0
        size: len_value
        type: osta_cs0
        if: len_value > 0
  osta_cs0:
    doc: OSTA Compressed Unicode string (UDF 2.1.1).
    seq:
      - id: compression_id
        type: u1
        doc: 8 = one byte per character (ISO-8859-1), 16 = UTF-16BE.
      - id: value
        size-eos: true
        type:
          switch-on: compression_id
          cases:
            8: str_latin1
            16: str_utf16be
  str_latin1:
    seq:
      - id: value
        size-eos: true
        type: str
        encoding: ISO-8859-1
  str_utf16be:
    seq:
      - id: value
        size-eos: true
        type: str
        encoding: UTF-16BE
  regid:
    doc: Entity identifier (ECMA-167 1/7.4).
    seq:
      - id: flags
        type: u1
      - id: identifier
        size: 23
        type: strz
        encoding: ASCII
      - id: identifier_suffix
        size: 8
  timestamp:
    seq:
      - id: type_and_timezone
        type: u2
        doc: Bits 12-15 type (1 = local time), bits 0-11 signed offset from UTC in minutes.
      - id: year
        type: s2
      - id: month
        type: u1
      - id: day
        type: u1
      - id: hour
        type: u1
      - id: minute
        type: u1
      - id: second
        type: u1
      - id: centiseconds
        type: u1
      - id: hundreds_of_microseconds
        type: u1
      - id: microseconds
        type: u1
  primary_volume_descriptor:
    seq:
      - id: volume_descriptor_sequence_number
        type: u4
      - id: primary_volume_descriptor_number
        type: u4
      - id: volume_identifier
        size: 32
        type: dstring
      - id: volume_sequence_number
        type: u2
      - id: max_volume_sequence_number
        type: u2
      - id: interchange_level
        type: u2
      - id: max_interchange_level
        type: u2
      - id: character_set_list
        type: u4
      - id: max_character_set_list
        type: u4
      - id: volume_set_identifier
        size: 128
        type: dstring
      - id: descriptor_character_set
        type: charspec
      - id: explanatory_character_set
        type: charspec
      - id: volume_abstract
        type: extent_ad
      - id: volume_copyright_notice
        type: extent_ad
      - id: application_identifier
        type: regid
      - id: recording_date_and_time
        type: timestamp
      - id: implementation_identifier
        type: regid
      - id: implementation_use
        size: 64
      - id: predecessor_volume_descriptor_sequence_location
        type: u4
      - id: flags
        type: u2
      - id: reserved
        size: 22
  anchor_volume_descriptor_pointer:
    seq:
      - id: main_vds
        type: extent_ad
        doc: Main Volume Descriptor Sequence extent.
      - id: reserve_vds
        type: extent_ad
        doc: Reserve Volume Descriptor Sequence extent.
      - id: reserved
        size: 480
  volume_descriptor_pointer:
    seq:
      - id: volume_descriptor_sequence_number
        type: u4
      - id: next_vds
        type: extent_ad
      - id: reserved
        size: 484
  implementation_use_volume_descriptor:
    seq:
      - id: volume_descriptor_sequence_number
        type: u4
      - id: implementation_identifier
        type: regid
        doc: '"*UDF LV Info" for UDF.'
      - id: implementation_use
        size: 460
        type: lv_info
        doc: Logical volume information (UDF 2.2.7.2).
  lv_info:
    seq:
      - id: lvi_charset
        type: charspec
      - id: logical_volume_identifier
        size: 128
        type: dstring
      - id: lv_info1
        size: 36
        type: dstring
      - id: lv_info2
        size: 36
        type: dstring
      - id: lv_info3
        size: 36
        type: dstring
      - id: implementation_identifier
        type: regid
      - id: implementation_use
        size: 128
  partition_descriptor:
    seq:
      - id: volume_descriptor_sequence_number
        type: u4
      - id: partition_flags
        type: u2
        doc: Bit 0 = space allocated.
      - id: partition_number
        type: u2
      - id: partition_contents
        type: regid
        doc: '"+NSR02" or "+NSR03" for a file system partition.'
      - id: partition_contents_use
        size: 128
        doc: Partition header descriptor (unallocated/freed space tables and bitmaps).
      - id: access_type
        type: u4
        enum: access_type
      - id: starting_location
        type: u4
        doc: First sector of the partition.
      - id: length
        type: u4
        doc: Length of the partition in sectors.
      - id: implementation_identifier
        type: regid
      - id: implementation_use
        size: 128
      - id: reserved
        size: 156
  logical_volume_descriptor:
    seq:
      - id: volume_descriptor_sequence_number
        type: u4
      - id: descriptor_character_set
        type: charspec
      - id: logical_volume_identifier
        size: 128
        type: dstring
      - id: logical_block_size
        type: u4
      - id: domain_identifier
        type: regid
        doc: '"*OSTA UDF Compliant" for UDF.'
      - id: file_set_descriptor_location
        type: long_ad
        doc: Logical volume contents use; in UDF, the location of the File Set Descriptor.
      - id: len_partition_maps
        -orig-id: mapTableLength
        type: u4
      - id: num_partition_maps
        type: u4
      - id: implementation_identifier
        type: regid
      - id: implementation_use
        size: 128
      - id: integrity_sequence
        type: extent_ad
        doc: Extent of the Logical Volume Integrity Sequence.
      - id: partition_maps
        size: len_partition_maps
        type: partition_maps
  partition_maps:
    seq:
      - id: maps
        type: partition_map
        repeat: expr
        repeat-expr: _parent.num_partition_maps
  partition_map:
    seq:
      - id: type
        type: u1
        doc: 1 = type 1 (physical partition), 2 = type 2 (virtual, sparable, metadata).
      - id: len_map
        type: u1
      - id: body
        size: len_map - 2
        type:
          switch-on: type
          cases:
            1: partition_map_type1
            2: partition_map_type2
  partition_map_type1:
    seq:
      - id: volume_sequence_number
        type: u2
      - id: partition_number
        type: u2
  partition_map_type2:
    seq:
      - id: reserved
        size: 2
      - id: partition_type_identifier
        type: regid
        doc: |
          e.g. "*UDF Virtual Partition", "*UDF Sparable Partition", "*UDF Metadata
          Partition".
  unallocated_space_descriptor:
    seq:
      - id: volume_descriptor_sequence_number
        type: u4
      - id: num_allocation_descriptors
        type: u4
      - id: allocation_descriptors
        type: extent_ad
        repeat: expr
        repeat-expr: num_allocation_descriptors
  logical_volume_integrity_descriptor:
    seq:
      - id: recording_date_and_time
        type: timestamp
      - id: integrity_type
        type: u4
        doc: 0 = open, 1 = close.
      - id: next_integrity_extent
        type: extent_ad
      - id: logical_volume_contents_use
        size: 32
        doc: In UDF, starts with the 64-bit unique ID for the next file.
      - id: num_partitions
        type: u4
      - id: len_implementation_use
        type: u4
      - id: free_space_table
        type: u4
        repeat: expr
        repeat-expr: num_partitions
      - id: size_table
        type: u4
        repeat: expr
        repeat-expr: num_partitions
      - id: implementation_use
        size: len_implementation_use
        type: lvid_implementation_use
  lvid_implementation_use:
    doc: UDF 2.2.6.4.
    seq:
      - id: implementation_identifier
        type: regid
      - id: num_files
        type: u4
      - id: num_directories
        type: u4
      - id: min_udf_read_revision
        type: u2
        doc: BCD, e.g. 0x0201 for UDF 2.01.
      - id: min_udf_write_revision
        type: u2
      - id: max_udf_write_revision
        type: u2
      - id: implementation_use
        size-eos: true
  file_set_descriptor:
    seq:
      - id: recording_date_and_time
        type: timestamp
      - id: interchange_level
        type: u2
      - id: max_interchange_level
        type: u2
      - id: character_set_list
        type: u4
      - id: max_character_set_list
        type: u4
      - id: file_set_number
        type: u4
      - id: file_set_descriptor_number
        type: u4
      - id: logical_volume_identifier_character_set
        type: charspec
      - id: logical_volume_identifier
        size: 128
        type: dstring
      - id: file_set_character_set
        type: charspec
      - id: file_set_identifier
        size: 32
        type: dstring
      - id: copyright_file_identifier
        size: 32
        type: dstring
      - id: abstract_file_identifier
        size: 32
        type: dstring
      - id: root_directory_icb
        type: long_ad
      - id: domain_identifier
        type: regid
      - id: next_extent
        type: long_ad
      - id: stream_directory_icb
        type: long_ad
      - id: reserved
        size: 32
  icb_tag:
    seq:
      - id: prior_recorded_num_direct_entries
        type: u4
      - id: strategy_type
        type: u2
      - id: strategy_parameter
        type: u2
      - id: max_num_entries
        type: u2
      - id: reserved
        type: u1
      - id: file_type
        type: u1
        enum: file_type
      - id: parent_icb_location
        type: lb_addr
      - id: flags
        type: u2
    instances:
      allocation_type:
        value: flags & 7
        enum: allocation_type
  file_entry:
    doc: |
      File Entry (ECMA-167 4/14.9) or, if `is_extended`, Extended File Entry
      (4/14.17).
    params:
      - id: is_extended
        type: bool
    seq:
      - id: icb_tag
        type: icb_tag
      - id: uid
        type: u4
      - id: gid
        type: u4
      - id: permissions
        type: u4
      - id: file_link_count
        type: u2
      - id: record_format
        type: u1
      - id: record_display_attributes
        type: u1
      - id: record_length
        type: u4
      - id: information_length
        type: u8
        doc: File size in bytes.
      - id: object_size
        type: u8
        if: is_extended
      - id: logical_blocks_recorded
        type: u8
      - id: access_time
        type: timestamp
      - id: modification_time
        type: timestamp
      - id: creation_time
        type: timestamp
        if: is_extended
      - id: attribute_time
        type: timestamp
      - id: checkpoint
        type: u4
      - id: reserved
        type: u4
        if: is_extended
      - id: extended_attribute_icb
        type: long_ad
      - id: stream_directory_icb
        type: long_ad
        if: is_extended
      - id: implementation_identifier
        type: regid
      - id: unique_id
        type: u8
      - id: len_extended_attributes
        type: u4
      - id: len_allocation_descriptors
        type: u4
      - id: extended_attributes
        size: len_extended_attributes
      - id: allocation_descriptors
        size: len_allocation_descriptors
        type: allocation_descriptors(icb_tag.allocation_type)
        doc: |
          Allocation descriptors, or the file data itself if `allocation_type` is
          `in_icb`.
    instances:
      is_directory:
        value: icb_tag.file_type == file_type::directory
      directory_entries:
        io: _root._io
        pos: _root.partition_start + allocation_descriptors.short_ads[0].position * _root.sector_size
        size: allocation_descriptors.short_ads[0].length
        type: directory
        if: is_directory and icb_tag.allocation_type == allocation_type::short_ad and len_allocation_descriptors >= 8
        doc: Directory contents (first extent only).
      directory_entries_long:
        io: _root._io
        pos: _root.partition_start + allocation_descriptors.long_ads[0].location.logical_block_num * _root.sector_size
        size: allocation_descriptors.long_ads[0].length
        type: directory
        if: is_directory and icb_tag.allocation_type == allocation_type::long_ad and len_allocation_descriptors >= 16
        doc: Directory contents (first extent only).
      directory_entries_in_icb:
        value: allocation_descriptors.embedded_directory
        if: is_directory and icb_tag.allocation_type == allocation_type::in_icb
  allocation_descriptors:
    params:
      - id: allocation_type
        type: u1
        enum: allocation_type
    seq:
      - id: short_ads
        type: short_ad
        repeat: eos
        if: allocation_type == allocation_type::short_ad
      - id: long_ads
        type: long_ad
        repeat: eos
        if: allocation_type == allocation_type::long_ad
      - id: embedded_data
        size-eos: true
        if: allocation_type == allocation_type::in_icb
    instances:
      embedded_directory:
        pos: 0
        size-eos: true
        type: directory
        if: allocation_type == allocation_type::in_icb
  directory:
    seq:
      - id: entries
        type: file_identifier_descriptor
        repeat: eos
  file_identifier_descriptor:
    seq:
      - id: tag
        type: tag
      - id: file_version_number
        type: u2
      - id: file_characteristics
        type: u1
        doc: 0x01 hidden, 0x02 directory, 0x04 deleted, 0x08 parent, 0x10 metadata.
      - id: len_file_identifier
        type: u1
      - id: icb
        type: long_ad
        doc: Location of the File Entry.
      - id: len_implementation_use
        type: u2
      - id: implementation_use
        size: len_implementation_use
      - id: file_identifier
        size: len_file_identifier
        type: osta_cs0
        if: len_file_identifier > 0
        doc: File name; absent for the parent directory entry.
      - id: padding
        size: (4 - (38 + len_implementation_use + len_file_identifier) % 4) % 4
    instances:
      is_directory:
        value: (file_characteristics & 0x02) != 0
      is_parent:
        value: (file_characteristics & 0x08) != 0
      is_deleted:
        value: (file_characteristics & 0x04) != 0
      file_entry:
        io: _root._io
        pos: _root.partition_start + icb.location.logical_block_num * _root.sector_size
        size: _root.sector_size
        type: descriptor
        if: not is_parent and not is_deleted
enums:
  tag_identifier:
    0x0001: primary_volume_descriptor
    0x0002: anchor_volume_descriptor_pointer
    0x0003: volume_descriptor_pointer
    0x0004: implementation_use_volume_descriptor
    0x0005: partition_descriptor
    0x0006: logical_volume_descriptor
    0x0007: unallocated_space_descriptor
    0x0008: terminating_descriptor
    0x0009: logical_volume_integrity_descriptor
    0x0100: file_set_descriptor
    0x0101: file_identifier_descriptor
    0x0102: allocation_extent_descriptor
    0x0103: indirect_entry
    0x0104: terminal_entry
    0x0105: file_entry
    0x0106: extended_attribute_header_descriptor
    0x0107: unallocated_space_entry
    0x0108: space_bitmap_descriptor
    0x0109: partition_integrity_entry
    0x010a: extended_file_entry
  access_type:
    0: unspecified
    1: read_only
    2: write_once
    3: rewritable
    4: overwritable
  file_type:
    0: unspecified
    1: unallocated_space_entry
    2: partition_integrity_entry
    3: indirect_entry
    4: directory
    5: regular
    6: block_device
    7: character_device
    8: extended_attributes
    9: fifo
    10: socket
    11: terminal_entry
    12: symlink
    13: stream_directory
    248: udf_virtual_allocation_table
    249: udf_real_time_file
    250: udf_metadata_file
    251: udf_metadata_mirror_file
    252: udf_metadata_bitmap_file
  allocation_type:
    0: short_ad
    1: long_ad
    2: extended_ad
    3: in_icb
