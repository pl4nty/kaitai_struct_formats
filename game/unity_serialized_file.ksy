# Imported from https://gist.githubusercontent.com/aki017/c3ee398ec1725e846115f389916bca4e/raw/7d6ebbfc5f9a6abf7668ffa99d70e9e23048856e/serialized_file.ksy
meta:
  id: unity_serialized_file
  title: Unity SerializedFile
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: header
    type: header
  - id: metadata
    type: metadata
  - id: object_data
    type: object_data

types:
  header:
    seq:
      - id: metadata_size
        type: s4
      - id: file_size
        type: u4
      - id: version
        type: s4
      - id: data_offset
        type: u4
      - id: endianness
        type: u1
        if: version >= 9
      - id: reserved
        size: 3
  metadata:
    seq:
      - id: type_tree
        type: type_tree
    types:
      type_tree:
        seq:
          - id: type_tree
            type:
              switch-on: '_root.header.version > 13 ? 3 : _root.header.version > 6 ? 2 : 1'
              cases:
                3: type_tree_v3
                2: type_tree_v2
                1: type_tree_v1
        types:
          type_tree_v3:
            seq:
              - id: revision
                type: strz
                encoding: ASCII
              - id: attributes
                type: s4le
              - id: embedded
                type: u1
              - id: num_base_classes
                type: s4le
              - id: base_classes
                type: base_class
                repeat: expr
                repeat-expr: num_base_classes
            types:
              base_class:
                seq:
                  - id: class_id
                    type: s4le
                  - id: script_id
                    type: unity_hash128
                    if: class_id < 0
                  - id: old_class_id
                    type: unity_hash128
                  - id: node
                    type: node
                    if: _parent.embedded == 1
            
              node:
                seq:
                  - id: num_fields
                    type: s4le
                  - id: string_table_len
                    type: s4le
                  - id: types
                    type: type_v2
                    repeat: expr
                    repeat-expr: num_fields
                  - id: string_table
                    size: string_table_len
                    type: string_table
                types:
                  string_table:
                    seq:
                      - id: data
                        type: strz
                        encoding: ASCII
                        repeat: eos
                  type_v2:
                    seq:
                      - id: version
                        type: s2le
                      - id: tree_level
                        type: u1
                      - id: is_array
                        type: u1
                      - id: type_offset
                        type: s4le
                      - id: name_offset
                        type: s4le
                      - id: size
                        type: s4le
                      - id: index
                        type: s4le
                      - id: meta_flag
                        type: s4le
          type_tree_v2:
            seq:
              - id: data
                size-eos: true
          type_tree_v1:
            seq:
              - id: data
                size-eos: true
        
      object_info_table:
        seq:
          - id: object_info_table
            type:
              switch-on: '_root.header.version > 14 ? 3 : _root.header.version > 13 ? 2 : 1'
              cases:
                3: v3
                2: v2
                1: v1
        types:
          v3:
            seq:
              - id: length
                type: s4
              - id: content
                type: content
                repeat: expr
                repeat-expr: length
            types:
              content:
                seq:
                  - id: path_id
                    type: s8
                  - id: object_info
                    type: v3
                types:
                  v3:
                    seq:
                      - id: stripped
                        type: u1
          v2:
            seq:
              - id: length
                type: s4
              - id: content
                type: content
                repeat: expr
                repeat-expr: length
            types:
              content:
                seq:
                  - id: path_id
                    type: s8
                  - id: object_info
                    type: v2
                types:
                  v2:
                    seq:
                      - id: data
                        size-eos: true
          v1:
            seq:
              - id: data
                size-eos: true
  object_data:
    seq:
      - id: object_data
        size: 0
  unity_hash128:
    seq:
      - id: bytes
        size: 16
