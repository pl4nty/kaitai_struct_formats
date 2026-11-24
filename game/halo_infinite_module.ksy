# Imported from https://gist.githubusercontent.com/matty45/8fcba7c9be3fad741c9b8673e23c6b44/raw/23e9b579c315e60709ee0570e937d27de350ff67/halo_infinite_module.ksy
meta:
  id: halo_infinite_module
  title: Halo Infinite module
  application: Halo Infinite
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
  - size: 8
    doc: padding!
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
    repeat-expr: header.num_resources
    if: header.num_resources > 0
  # The rest is all tag and resource data https://github.com/ElDewrito/AusarDocs/blob/master/FileFormats/CachedTag.md#tag-data
types:
  header:
    seq:
      - id: magic
        contents: 'mohd'
      - id: version
        type: u4
        doc: Version of the module file.
      - id: module_id
        type: u8
        doc: Unique module ID number I think?
      - id: files_count
        type: u4
        doc: Number of files stored in the module
      - id: unk3
        type: u4
      - id: num_loaded_tags
        type: u4
        doc: Number of tags in the load manifest (0 if the module doesn't have one)
      - id: unk5
        type: u4
      - id: first_resource_index
        type: u4
        doc: Index of the first resource entry (numFiles - numResources)
      - id: file_name_size
        type: u4
        doc: Size of the filename data in the module
      - id: num_resources
        type: u4
        doc: Number of resource files in the module
      - id: num_file_blocks
        type: u4
        doc: Number of file blocks in the module
      - id: build_version
        type: u8
        doc: |
          (This is always 0xd091af72a3ec9800 and it's not used at runtime, so calling it
          the build version ID is the best we can do right now)
      - id: unk6
        type: u4
      - id: unk8
        type: u4
      - id: unk9
        type: u4
      - id: unk10
        type: u4
  file_list:
    seq:
      - id: possible_name_offset
        type: u4
        doc: This might be the offset of the filename in the filename data
      - id: parent_file_index
        type: u4
        doc: Used with resources to point back to the parent file. -1 = none
      - id: resource_count
        type: u2
        doc: Number of resources this file owns
      - id: block_count
        type: u2
        doc: The number of blocks that make up the file.
      - id: first_block_index
        type: u4
        doc: The index of the first block in the file.
      - id: first_resource_index
        type: u4
      - id: group_tag
        type: u4
        doc: If the file is a tag, this holds the group tag of the file (e.g. bipd).
      - id: local_data_offset
        type: u4
        doc: |
          The offset of the first block in the file, relative to the start of the data
          area in the module. This area follows the block list.
      - id: unk1
        type: u4
      - id: total_compressed_size
        type: u4
      - id: total_uncompressed_size
        type: u4
      - id: unk2
        type: u4
      - id: unk3
        type: u4
      - id: unk4
        type: u4
      - id: unk69
        type: u8
      - id: header_size
        type: u4
        doc: |
          The size of the file's uncompressed header? To get string:
          (header.file_name_size+file_list.string_offset)
      - id: string_offset
        type: u4
      - id: unk5
        type: u4
      - id: unk6
        type: u4
      - id: unk7
        type: u4
      - id: unk8
        type: u4
      - id: unk9
        type: u4
  block_list:
    seq:
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
