# Imported from https://gist.githubusercontent.com/matty45/8fcba7c9be3fad741c9b8673e23c6b44/raw/23e9b579c315e60709ee0570e937d27de350ff67/halo_infinite_tag.ksy
meta:
  id: halo_infinite_tag
  title: Halo Infinite tag
  application: Halo Infinite
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: header
  - id: tag_dependency
    type: tag_dependency_list
    repeat: expr
    repeat-expr: header.dependency_count
    if: header.dependency_count > 0
  - id: data_block_list
    type: data_block_list
    repeat: expr
    repeat-expr: header.data_block_count
    if: header.data_block_count > 0
  - id: tag_struct_list
    type: tag_struct_list
    repeat: expr
    repeat-expr: header.tag_struct_count  
    if: header.tag_struct_count > 0
  - id: data_reference_list
    type: data_reference_list
    repeat: expr
    repeat-expr: header.data_reference_count  
    if: header.data_reference_count > 0
  - id: tag_reference_list
    type: tag_reference_list
    repeat: expr
    repeat-expr: header.tag_reference_count  
    if: header.tag_reference_count > 0
  - id: string_table
    size: header.string_table_size
    type: string_table
    if: header.string_table_size > 0
  # zoneset, tag, resource and string table are somewhere under here (more research needed!)
    

types:
  header:
    seq:
      - id: magic
        contents: 'ucsh'
      - id: version
        type: u4
        doc: Version of the tag file.
      - id: unk_id
        type: u8
        doc: Some ID number
      - id: asset_checksum
        type: u8
        doc: |
          Murmur3_x64_128 hash of (what appears to be) the original file that this file
          was built from. This is not always the same thing as the file stored in the
          module.
      - id: dependency_count
        type: u4
        doc: Number of tag dependencies
      - id: data_block_count
        type: u4
      - id: tag_struct_count
        type: u4
      - id: data_reference_count
        type: u4
      - id: tag_reference_count
        type: u4
      - id: string_table_size
        type: u4
      - id: string_id_count
        type: u4
      - id: zoneset_data_size
        type: u4
      - id: unk
        type: u4
      - id: data_size
        type: u4
      - id: resource_data_size
        type: u4
      - id: unk1
        type: u4
      - id: unk2
        type: u4
      - id: unk3
        type: u4
  tag_dependency_list:
    seq:
      - id: tag_group
        type: u4
      - id: name_offset
        type: u4
      - id: asset_id
        type: u8
      - id: global_id
        type: u4
      - id: unk
        type: u4
  data_block_list:
    seq:
      - id: size
        type: u4
      - id: unk
        type: u2
      - id: section
        type: b16
        doc: (enum16) 0 = Header, 1 = Tag Data, 2 = Resource Data
      - id: offset
        type: u8
  tag_struct_list:
    seq:
      - id: guid
        size: 16
        doc: |
          Type GUID. This is used to write in a static pointer to type info located in the
          .rdata section of the executable. (At load time, the first 8 bytes of this are
          replaced with the type info pointer for efficiency reasons.)
      - id: type
        type: b16
        doc: (enum16) 0 = Main Struct, 1 = Tag Block, 2 = Resource, 3 = Custom (see https://github.com/ElDewrito/AusarDocs/blob/master/FileFormats/CachedTag.md#main-struct-type-0)
      - id: unk
        type: u2
        doc: padding?
      - id: target_index
        type: u4
        doc: |
          For Main Struct and Tag Block structs, the index of the block containing the
          struct. For Resource structs, this (probably) is the index of the resource. This
          can be -1 if the tag field doesn't point to anything (null Tag Blocks or Custom
          structs).
      - id: field_block
        type: u4
        doc: |
          The index of the data block containing the tag field which refers to this
          struct. Can be -1 for the Main Struct.
      - id: field_offset
        type: u4
        doc: |
          The offset of the tag field inside the data block. (Unlike in Halo Online, this
          points to the tag field, not the pointer inside the tag field. Some tag fields
          for structs don't even have a pointer.)
  data_reference_list:
    seq:
      - id: parent_struct_index
        type: u4
        doc: The index of the tag struct containing the tag field.
      - id: unk
        type: u4
      - id: target_index
        type: u4
        doc: |
          The index of the data block containing the referenced data. Can be -1 for null
          references. Halo 5: At load time, the targetIndex is used to determine the final
          address of the data block containing the data, and this 64-bit pointer is
          written to fieldOffset inside fieldBlock. (Some sort of type info pointer is
          written to fieldOffset + 0x8. Need to look into this.)
      - id: field_block
        type: u4
        doc: The index of the data block containing the tag field.
      - id: field_offset
        type: u4
        doc: The offset of the tag field inside the data block.
  tag_reference_list:
    seq:
      - id: field_block
        type: u4
        doc: The index of the data block containing the tag field.
      - id: field_offset
        type: u4
        doc: |
          The offset of the tag field inside the data block. (Unlike in Halo Online, this
          points to the tag field, not the handle inside the tag field.)
      - id: name_offset
        type: u4
        doc: The offset of the tag filename within the String Table.
      - id: dependency_index
        type: u4
        doc: |
          The index of the tag dependency in the Tag Dependency List. Can be -1 for null
          tag references. Halo 5: At load time, the dependencyIndex and global tag ID are
          used to determine the 32-bit local tag handle, which is written to fieldOffset +
          0x1C inside fieldBlock. (Some sort of type info pointer is written to
          fieldOffset. Need to look into this.)
  string_table:
    seq:
      - id: string
        type: str
        terminator: 0
        encoding: UTF-8
        repeat: eos
        doc: filename
  string_id_list:
    seq:
      - id: unknown0
        type: u4
        doc: flags?
      - id: string_offset
        type: u4
        doc: The offset of the string value within the String Table.
