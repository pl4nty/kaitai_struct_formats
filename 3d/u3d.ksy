meta:
  id: u3d
  title: Universal 3D (U3D) file
  file-extension: u3d
  license: CC0-1.0
  ks-version: '0.9'
  encoding: UTF-8
  endian: le
doc: |
  Universal 3D (U3D), standardized as ECMA-363, is a compressed format for 3D
  scenes (meshes, point and line sets, nodes, lights, views, shaders,
  materials, textures and animations).

  A file is a sequence of blocks, each with a block type, the size of its
  data and the size of its meta data, followed by the data and the meta data,
  each padded with zero bytes to a multiple of 4 bytes. The first block is
  the file header (block type `U3D\0`), followed by the declaration blocks
  and then the continuation blocks.

  All block data is written through the bit encoding algorithm of the
  standard, but values written uncompressed (as in the file header, the
  priority update block and the leading name of the other blocks) come out
  as plain little-endian integers. This spec parses the block structure, the
  file header, priority update blocks, the meta data key/value pairs, and the
  name (a string with a 16-bit length) that starts the data of all other
  block types; the rest of the data is left raw, as it may contain
  arithmetic-coded values.
doc-ref: https://www.ecma-international.org/wp-content/uploads/ECMA-363_4th_edition_june_2007.pdf
seq:
  - id: header_block
    type: block
    valid:
      expr: _.block_type == block_type::file_header
  - id: blocks
    type: block
    repeat: eos
instances:
  header:
    value: header_block.data.as<file_header>
types:
  block:
    seq:
      - id: block_type
        type: u4
        enum: block_type
      - id: len_data
        type: u4
      - id: len_meta_data
        type: u4
      - id: data
        size: len_data
        type:
          switch-on: block_type
          cases:
            block_type::file_header: file_header
            block_type::priority_update: priority_update
            _: named_block_data
      - id: data_padding
        size: (4 - len_data % 4) % 4
      - id: meta_data
        size: len_meta_data
        type: meta_data
        if: len_meta_data != 0
      - id: meta_data_padding
        size: (4 - len_meta_data % 4) % 4
    instances:
      is_new_object_block:
        value: block_type.to_i >= 0x100 and block_type.to_i <= 0xffffff
        doc: |
          True for a block of an object type defined by a New Object Type block
          (extensible profile).
  file_header:
    seq:
      - id: major_version
        type: s2
        doc: |
          0 for the current version; negative for encoders whose compliance has not been
          validated.
      - id: minor_version
        type: s2
        doc: Implementation dependent, e.g. the version of the encoder.
      - id: profile
        type: profile_flags
      - id: len_declarations
        type: u4
        doc: |
          Size of the declaration block section, including the file header block and
          the padding.
      - id: len_file
        type: u8
        doc: Size of the file.
      - id: character_encoding
        type: u4
        doc: IANA MIBenum of the encoding of strings; 106 (UTF-8).
      - id: units_scaling_factor
        type: f8
        if: profile.defined_units
        doc: Multiplying positions and lengths by this factor converts them to meters.
  profile_flags:
    meta:
      bit-endian: le
    seq:
      - id: reserved1
        type: b1
      - id: extensible
        type: b1
        doc: The file may contain New Object Type blocks and other extensibility features.
      - id: no_compression
        type: b1
        doc: Compressed values are replaced by uncompressed ones in the whole file.
      - id: defined_units
        type: b1
        doc: Objects are defined with units, given by `units_scaling_factor`.
      - id: reserved2
        type: b28
  priority_update:
    doc: |
      Continuation of the file header: the following continuation blocks have
      priority number `new_priority`.
    seq:
      - id: new_priority
        type: u4
  named_block_data:
    seq:
      - id: name
        type: u3d_string
        doc: Name of the object declared or continued by the block.
      - id: rest
        size-eos: true
        doc: The rest of the block data, specific to the block type.
  u3d_string:
    seq:
      - id: len_value
        type: u2
      - id: value
        size: len_value
        type: str
  meta_data:
    seq:
      - id: num_pairs
        type: u4
      - id: pairs
        type: key_value_pair
        repeat: expr
        repeat-expr: num_pairs
  key_value_pair:
    seq:
      - id: attributes
        type: u4
        doc: |
          Bit 0x1 set if the value is binary, 0x2 hidden, 0x10 used when
          double-clicked, 0x20 value and 0x40 key displayed in a right-click menu,
          0x100 action, 0x200 file, 0x400 MIME data.
      - id: key
        type: u3d_string
      - id: string_value
        type: u3d_string
        if: not is_binary
      - id: len_binary_value
        type: u4
        if: is_binary
      - id: binary_value
        size: len_binary_value
        if: is_binary
    instances:
      is_binary:
        value: attributes & 1 != 0
enums:
  block_type:
    0x00443355: file_header
    0xffffff12: file_reference
    0xffffff14: modifier_chain
    0xffffff15: priority_update
    0xffffff16: new_object_type
    0xffffff21: group_node
    0xffffff22: model_node
    0xffffff23: light_node
    0xffffff24: view_node
    0xffffff31: clod_mesh_declaration
    0xffffff36: point_set_declaration
    0xffffff37: line_set_declaration
    0xffffff3b: clod_base_mesh_continuation
    0xffffff3c: clod_progressive_mesh_continuation
    0xffffff3e: point_set_continuation
    0xffffff3f: line_set_continuation
    0xffffff41: glyph_2d_modifier
    0xffffff42: subdivision_modifier
    0xffffff43: animation_modifier
    0xffffff44: bone_weight_modifier
    0xffffff45: shading_modifier
    0xffffff46: clod_modifier
    0xffffff51: light_resource
    0xffffff52: view_resource
    0xffffff53: lit_texture_shader
    0xffffff54: material_resource
    0xffffff55: texture_declaration
    0xffffff56: motion_resource
    0xffffff5c: texture_continuation
