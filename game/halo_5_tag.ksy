# Imported from https://gist.githubusercontent.com/matty45/f786b92d28417b1c085712c41ef8393a/raw/774d95f9b8ab86e50a6f5f01853254e674ce0072/halo_5_tag.ksy
meta:
  id: halo_5_tag
  application: "Halo 5: Forge"
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: header
  - id: tag_dependency_list
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
  - id: string_id_list
    type: string_id_list
    repeat: expr
    repeat-expr: header.string_id_count
    if: header.string_id_count > 0
  - id: string_table
    size: header.string_table_size
    type: string_table
    if: header.string_table_size > 0
  - id: zoneset_info_header
    type: zoneset_info_header
    if: header.zoneset_data_size > 0
  - id: zoneset_entry
    type: zoneset_entry
    repeat: expr
    repeat-expr: zoneset_info_header.zoneset_count
    if: zoneset_info_header.zoneset_count > 0
  - id: zoneset_tags
    type: zoneset_tag_list(zoneset_entry[_index].tag_count)
    repeat: expr
    repeat-expr: zoneset_info_header.zoneset_count
    if: zoneset_info_header.zoneset_count > 0
    doc: Tags of each zoneset entry, one list per entry.
  # Rest is all tag and resource data (need more research on my part) https://github.com/ElDewrito/AusarDocs/blob/master/FileFormats/CachedTag.md#tag-data

types:
  header:
    seq:
      - id: magic
        contents: 'ucsh'
      - id: version
        type: s4
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
      - id: unk
        type: s4
      - id: dependency_count
        type: s4
      - id: data_block_count
        type: s4
      - id: tag_struct_count
        type: s4
      - id: data_reference_count
        type: s4
      - id: tag_reference_count
        type: s4
      - id: string_id_count
        type: s4
      - id: string_table_size
        type: u4
      - id: zoneset_data_size
        type: u4
      - id: header_size
        type: u4
      - id: data_size
        type: u4
      - id: resource_data_size
        type: u4
      - id: header_alignment
        type: s1
        doc: |
          Power of 2 to align the header buffer to (e.g. 4 = align to a multiple of 16
          bytes).
      - id: tag_data_alignment
        type: s1
        doc: Power of 2 to align the tag data buffer to.
      - id: resouce_data_alignment
        type: s1
        doc: Power of 2 to align the resource data buffer to.
      - id: unk1
        type: s1
      - id: unk2
        type: s4
  tag_dependency_list:
    seq:
      - id: tag_group
        type: s4
      - id: name_offset
        type: u4
        doc: Offset of the tag filename in the String Table.
      - id: asset_id
        type: s8
      - id: global_id
        type: s4
      - id: unk
        type: s4
  data_block_list:
    seq:
      - id: size
        type: u4
      - id: unk
        type: s2
        doc: Offset of the tag filename in the String Table.
      - id: section
        type: u2
        doc: "(enum16) 	0 = Header, 1 = Tag Data, 2 = Resource Data"
      - id: offset
        type: u8
        doc: The offset of the start of the data block, relative to the start of its section.
  tag_struct_list:
    seq:
      - id: guid
        size: 16
        doc: |
          Type GUID. This is used to write in a static pointer to type info located in the
          .rdata section of the executable. (At load time, the first 8 bytes of this are
          replaced with the type info pointer for efficiency reasons.)
      - id: type
        type: u2
        doc: (enum16) 0 = Main Struct, 1 = Tag Block, 2 = Resource, 3 = Custom (see https://github.com/ElDewrito/AusarDocs/blob/master/FileFormats/CachedTag.md#main-struct-type-0
      - id: unk
        type: s2
        doc: padding?
      - id: target_index
        type: s4
        doc: |
          For Main Struct and Tag Block structs, the index of the block containing the
          struct. For Resource structs, this (probably) is the index of the resource. This
          can be -1 if the tag field doesn't point to anything (null Tag Blocks or Custom
          structs).
      - id: field_block
        type: s4
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
        type: s4
        doc: The index of the tag struct containing the tag field.
      - id: unk
        type: s4
      - id: target_index
        type: s4
        doc: |
          The index of the data block containing the referenced data. Can be -1 for null
          references. At load time, the targetIndex is used to determine the final address
          of the data block containing the data, and this 64-bit pointer is written to
          fieldOffset inside fieldBlock. (Some sort of type info pointer is written to
          fieldOffset + 0x8. Need to look into this.)
      - id: field_block
        type: s4
        doc: The index of the data block containing the tag field.
      - id: field_offset
        type: u4
        doc: The index of the data block containing the tag field.
  tag_reference_list:
    seq:
      - id: field_block
        type: s4
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
        type: s4
        doc: |
          The index of the tag dependency in the Tag Dependency List. Can be -1 for null
          tag references. At load time, the dependencyIndex and global tag ID are used to
          determine the 32-bit local tag handle, which is written to fieldOffset + 0x1C
          inside fieldBlock. (Some sort of type info pointer is written to fieldOffset.
          Need to look into this.)
  string_id_list:
    seq:
      - id: unk
        type: u4
        doc: Flags?
      - id: string_offset
        type: u4
        doc: The offset of the string value within the String Table.
  string_table:
    seq:
      - id: string
        type: str
        terminator: 0
        encoding: UTF-8
        repeat: eos
  zoneset_info_header:
    seq:
      - id: zoneset_count
        type: s8
      - id: zoneset_list_offset
        type: s8
  zoneset_tag_list:
    params:
      - id: tag_count
        type: s8
    seq:
      - id: tags
        type: zoneset_tag
        repeat: expr
        repeat-expr: tag_count
  zoneset_entry:
    seq:
      - id: name
        type: s4
        doc: string_id
      - id: unk
        type: s4
      - id: unk1
        type: s8
      - id: unk2
        type: s8
      - id: tag_count
        type: s8
      - id: tag_list_offset
        type: u8
  zoneset_tag:
    seq:
      - id: global_id
        type: u4
      - id: zoneset_name
        type: s4
        doc: string_id
