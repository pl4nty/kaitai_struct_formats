# Imported from https://github.com/HenryOfCarim/GameFilesTemplates/blob/f61646c9173f4f9052e2fa8421c17e4bea7776b9/albam/engines/hexn/edgemodel.ksy
# Version 15 header and buffer_weights fix from https://github.com/Brachi/albam/blob/6242aaff6c4145732b9b78213f2d7cf9b84d4545/albam/engines/hexn/structs/edgemodel.ksy
meta:
  id: hexane_edgemodel
  title: Hexane Engine Model Format
  file-extension: edgemodel
  license: CC0-1.0
  ks-version: 0.8
  endian: le

seq:
  - {id: header, type: edge_header}
  - {id: meshes_header, type: mesh_header, repeat: expr, repeat-expr: header.num_meshes}

types:
  edge_header:
    seq:
      - {id: id_magic, contents: [0x46, 0x4d, 0x36, 0x53]}
      - {id: version, type: u4}
      - {id: num_models, type: u4}
      - {id: num_meshes, type: u4}
      # Version 15 has a 144-byte header against 17/18's 208: the same fields
      # in the same order, minus the ones guarded by `version >= 17` below.
      - {id: ofs_meshes_start, type: u4}
      - {id: ofs_meshes_end, type: u4, if: version >= 17}
      - {id: ofs_meshes_info, type: u4, if: version >= 17}
      - {id: num_bones, type: u4}
      - {id: ofs_bones, type: u4}
      - {id: reserved_01, type: u4, if: version >= 17}
      - {id: reserved_02, type: u4, if: version >= 17}
      - {id: reserved_03, type: u4}
      - {id: unk_matrix_1, type: f4, repeat: expr, repeat-expr: 8}
      - {id: unk_matrix_2, type: matrix4x4}
      - {id: num_material_per_mesh, type: u4}
      - {id: ofs_unk_01, type: u4}
      - {id: ofs_unk_02, type: u4}
      - {id: reserved_04, type: u4}
      - {id: ofs_models_start, type: u4, repeat: expr, repeat-expr: 5, if: version >= 17} # TODO: better name
      - {id: ofs_models_end, type: u4, repeat: expr, repeat-expr: 5, if: version >= 17}  # TODO: better name
      - {id: reserved_05, type: u4, if: version >= 17}
      - {id: reserved_06, type: u4, if: version >= 17}

  mesh_header:
    seq:
      - {id: num_groups, type: u4}
      - {id: ofs_data, type: u4}
      # Version 15 stores ofs_materials before the lod word, 17/18 after it.
      - {id: lod_v17, type: u4, if: _root.header.version >= 17}
      - {id: ofs_materials, type: u4}
      - {id: lod_v15, type: u4, if: _root.header.version < 17}
      - {id: matrix_4x2_unk, type: f4, repeat: expr, repeat-expr: 8}
      - {id: matrix_4x4_unk, type: matrix4x4}
      - {id: unk_ofs_1, type: u4}
      - {id: unk_ofs_2, type: u4}
      - {id: unk_ofs_3, type: u4}
      - {id: unk_ofs_4, type: u4}
      - {id: unk_ofs_5, type: u4}
      - {id: unk_flags_1, type: u4}
      - {id: unk_ofs_6, type: u4}
      - {id: reserved_01, type: u4}
    instances:
      lod:
        value: "_root.header.version >= 17 ? lod_v17 : lod_v15"
      mesh:
        {pos: ofs_data, type: edgemesh}
      materials:
        {pos: ofs_materials, type: materials_table}

  materials_table:
    seq:
      - {id: offsets, type: u4, repeat: expr, repeat-expr: _parent._parent.header.num_material_per_mesh}
      # offsets[i] each point to their own null-terminated .matb path. The
      # strings are contiguous, so they are read sequentially.
      - {id: all_materials, type: str, terminator: 0, encoding: ASCII,
         repeat: expr, repeat-expr: _parent._parent.header.num_material_per_mesh}
    instances:
      first_material:
        value: all_materials[0]

  vec3:
    seq:
      - {id: x, type: f4}
      - {id: y, type: f4}
      - {id: z, type: f4}
      - {id: reserved_03, type: u4}

  vec4:
    seq:
      - {id: x, type: f4}
      - {id: y, type: f4}
      - {id: z, type: f4}
      - {id: w, type: f4}

  matrix4x4:
    seq:
      - {id: row_1, type: vec4}
      - {id: row_2, type: vec4}
      - {id: row_3, type: vec4}
      - {id: row_4, type: vec4}

  edgemesh:
    seq:
      - {id: unk_1_flag, type: u2}
      - {id: unk_2_constant, type: u2}
      - {id: unk_3_flag, type: u4}
      - {id: num_vertices, type: u2}
      - {id: num_indices, type: u2}
      - {id: unk_4_flag, type: u4}
      - {id: ofs_buffer_indices, type: u4}
      - {id: size_buffer_indices, type: u4}
      - {id: reserved_01, type: u4, repeat: expr, repeat-expr: 5}
      - {id: ofs_buffer_vertices, type: u4}
      - {id: size_buffer_vertices, type: u4}
      - {id: reserved_06, type: u4}
      - {id: unk_5_flag, type: u4}
      - {id: size_buffer_weights, type: u4}
      - {id: ofs_buffer_weights, type: u4}
      - {id: unk_6_flag, type: u4}
      - {id: num_vertices_padding, type: u4} # ??
      - {id: reserved_02, type: u4, repeat: expr, repeat-expr: 9}
      - {id: unk_7_offset, type: u4}
      - {id: unk_8_offset, type: u4}
      - {id: reserved_16, type: u4}
      - {id: unk_9_size, type: u2}
      - {id: unk_10_size, type: u2}
    instances:
      buffer_indices:
        {pos: ofs_buffer_indices, size: size_buffer_indices}
      buffer_vertices:
        {pos: ofs_buffer_vertices, size: size_buffer_vertices}
      buffer_weights:
        {pos: ofs_buffer_weights, size: size_buffer_weights}
