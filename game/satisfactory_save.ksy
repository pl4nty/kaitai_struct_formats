# Imported from https://github.com/polymorfiq/file_parsing_ex/blob/ba7419fbb651c07bda655ab56cc55045dfceaa2c/priv/satisfactory_save_file.ksy
meta:
  id: satisfactory_save
  title: Satisfactory Save File
  license: LicenseRef-All-Rights-Reserved
seq:
  - id: header
    type: save_file_header
  - id: compressed_data
    type: compressed_save_file_body
    repeat: eos
types:
  save_file_header:
    seq:
      - id: save_header_version
        type: s4le
      - id: save_version
        type: s4le
      - id: build_version
        type: s4le
      - id: map_name
        type: ue_string
      - id: map_options
        type: ue_string
      - id: session_name
        type: ue_string
      - id: played_seconds
        type: s4le
      - id: save_timestamp
        type: s8le
      - id: session_visibility
        type: u1
      - id: editor_object_version
        type: s4le
      - id: mod_metadata
        type: ue_string
      - id: mod_flags
        type: s4le
      - id: save_identifier
        type: ue_string
      - id: is_partitioned_world
        type: s4le
      - id: save_data_hash
        type: md5_hash
      - id: is_creative_mode_enabled
        type: s4le

  compressed_save_file_body:
    seq:
      - id: package_sig
        contents: [0xC1, 0x83, 0x2A, 0x9E]
      - id: archive_header
        type: s4le
      - id: max_chunk_size
        type: s8le
      - id: compression_algo
        type: u1
      - id: compressed_size
        type: s8le
      - id: uncompressed_size
        type: s8le
      - id: compressed_size_repeat
        type: s8le
      - id: uncompressed_size_repeat
        type: s8le
      - id: chunk
        size: compressed_size
        type: save_file_body
        process: zlib

  save_file_body:
    seq:
      - id: all_data
        size-eos: true
  #      - id: unmcompressed_size
  #        type: s4le
  #      - id: sublevel_count
  #        type: s4le
  #      - id: levels
  #        type: level
  #        repeat: expr
  #        repeat-expr: sublevel_count
  #      - id: obj_refs_count
  #        type: s4le
  #      - id: obj_refs
  #        type: object_reference
  #        repeat: expr
  #        repeat-expr: obj_refs_count

  level:
    seq:
      - id: sublevel_name
        type: ue_string
      - id: obj_header_collectables_size
        type: s4le
      - id: obj_header_count
        type: s4le
      - id: obj_headers
        type: object_header
        repeat: expr
        repeat-expr: obj_header_count
      - id: collectables_count
        type: s4le
      - id: collectables
        type: object_reference
        repeat: expr
        repeat-expr: collectables_count
      - id: objects_size
        type: s4le
      - id: object_count
        type: s4le
      - id: objects
        type:
          switch-on: obj_headers[_index].header_type
          cases:
            0: component_object
            1: actor_object
        repeat: expr
        repeat-expr: object_count
      - id: second_collectables_count
        type: s4le
      - id: second_collectables
        type: object_reference
        repeat: expr
        repeat-expr: second_collectables_count

  object_header:
    seq:
      - id: header_type
        type: s4le
      - id: contents
        type:
          switch-on: header_type
          cases:
            0: component_header
            1: actor_header

  actor_header:
    seq:
      - id: type_path
        type: ue_string
      - id: root_object
        type: ue_string
      - id: instance_name
        type: ue_string
      - id: need_transform
        type: s4le
      - id: rotation_x
        type: f4le
      - id: rotation_y
        type: f4le
      - id: rotation_z
        type: f4le
      - id: rotation_w
        type: f4le
      - id: pos_x
        type: f4le
      - id: pos_y
        type: f4le
      - id: pos_z
        type: f4le
      - id: scale_x
        type: f4le
      - id: scale_y
        type: f4le
      - id: scale_z
        type: f4le
      - id: was_placed_in_level
        type: s4le

  component_header:
    seq:
      - id: type_path
        type: ue_string
      - id: root_object
        type: ue_string
      - id: instance_name
        type: ue_string
      - id: parent_actor_name
        type: ue_string

  actor_object:
    seq:
      - id: size
        type: s4le
      - id: contents
        size: size
        type: actor_object_contents

  actor_object_contents:
    seq:
      - id: parent_obj_root
        type: ue_string
      - id: parent_obj_name
        type: ue_string
      - id: component_count
        type: s4le
      - id: components
        type: component_object
        repeat: expr
        repeat-expr: component_count
      - id: properties
        type: property_list

  component_object:
    seq:
      - id: size
        type: s4le
      - id: contents
        size: size
        type: component_object_contents

  component_object_contents:
    seq:
      - id: properties
        type: property_list

  object_reference:
    seq:
      - id: level_name
        type: ue_string
      - id: path_name
        type: ue_string

  property_list:
    seq:
      - id: properties
        type: property
        repeat: until
        repeat-until: _.name.contents_utf8 == "None"

  property:
    seq:
      - id: name
        type: ue_string

  ue_string:
    seq:
      - id: length
        type: s4le
      - id: contents_utf8
        size: length
        type: strz
        encoding: UTF-8
        if: length >= 0
      - id: contents_utf16
        size: length * 2
        type: strz
        encoding: UTF-16LE
        if: length < 0

  md5_hash:
    seq:
      - id: data
        size: 20
