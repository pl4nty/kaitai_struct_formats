# Imported from https://gist.githubusercontent.com/matty45/f786b92d28417b1c085712c41ef8393a/raw/774d95f9b8ab86e50a6f5f01853254e674ce0072/halo_5_module.ksy
meta:
  id: halo_5_module
  application: "Halo 5: Forge"
  file-extension: module
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: header
  - id: file
    type: file_list
    repeat: expr
    repeat-expr: header.files_count
    if: header.files_count > 0
  - id: filename_table
    size: header.file_name_size
    type: string_table
    if: header.file_name_size > 0
  - id: resource_list
    type: resource_list
    repeat: expr
    repeat-expr: header.num_resources
    if: header.num_resources > 0
  - id: block
    type: block_list
    repeat: expr
    repeat-expr: header.num_file_blocks
    if: header.num_file_blocks > 0
  # The rest is all tag and resource data https://github.com/ElDewrito/AusarDocs/blob/master/FileFormats/CachedTag.md#tag-data
types:
  header:
    seq:
      - id: magic
        contents: 'mohd'
      - id: version
        type: s4
        doc: Version of the module file.
      - id: module_id
        type: u8
        doc: Unique module ID number
      - id: files_count
        type: s4
        doc: Number of files stored in the module
      - id: num_loaded_tags
        type: s4
        doc: Number of tags in the load manifest (0 if the module doesn't have one)
      - id: first_resource_index
        type: s4
        doc: Index of the first resource entry (numFiles - numResources)
      - id: file_name_size
        type: s4
        doc: Size of the filename data in the module
      - id: num_resources
        type: s4
        doc: Number of resource files in the module
      - id: num_file_blocks
        type: s4
        doc: Number of file blocks in the module
      - id: build_version
        type: u8
        doc: |
          (This is always 0xd091af72a3ec9800 and it's not used at runtime, so calling it
          the build version ID is the best we can do right now)
      - id: checksum
        type: u8
  file_list:
    seq:
      - id: name_offset
        type: s4
        doc: Offset of the filename in the filename data
      - id: parent_file_index
        type: s4
        doc: Used with resources to point back to the parent file. -1 = none
      - id: resource_count
        type: s4
        doc: Number of resources this file owns
      - id: first_resource_index
        type: s4
        doc: The index of the first block in the file.
      - id: block_count
        type: s4
      - id: first_block_index
        type: s4
      - id: data_offset
        type: u8
      - id: total_compressed_size
        type: u4
      - id: total_uncompressed_size
        type: u4
      - id: header_alignment
        type: u1
      - id: tag_data_alignment
        type: u1
      - id: resource_data_alignment
        type: u1
      - id: flags
        type: u1
      - id: global_tag_id
        type: s4
      - id: asset_id
        type: s8
      - id: asset_checksum
        type: u8
      - id: tag_group
        type: s4
      - id: uncompressed_header_size
        type: u4
      - id: uncompressed_tag_data_size
        type: u4
      - id: uncompressed_resource_data_size
        type: u4
      - id: header_block_count
        type: s2
      - id: tag_data_block_count
        type: s2
      - id: resource_block_count
        type: s2
      - id: padding
        type: s2
  block_list:
    seq:
      - id: checksum
        type: u8
        doc: |
          Murmur3_x64_128 hash of the uncompressed block data (the upper 64 bits are
          discarded)
      - id: comp_offset
        type: u4
        doc: The offset of this block relative to the start of the file's compressed data.
      - id: comp_size
        type: u4
        doc: The size of the compressed data.
      - id: decomp_offset
        type: u4
        doc: The offset of the block's uncompressed data in the uncompressed file.
      - id: decomp_size
        type: u4
        doc: The size of the block's data after it is uncompressed.
      - id: b_compressed
        type: u4
        doc: |
          true if the block data is compressed using Oodle, false if it should just be
          read verbatim
      - id: padding
        type: s4
  string_table:
    seq:
      - id: string
        type: str
        terminator: 0
        encoding: UTF-8
        repeat: eos
        doc: filename
  resource_list:
    seq:
      - id: resource
        type: u4
        doc: |
          This resource list immediately follows the filename data. It is a list of 4-byte
          indices which point to files in the File List that contain resource data.
