meta:
  id: dxut_sdkmesh
  title: DXUT SDK mesh
  application:
    - DirectX SDK samples (DXUT)
    - DirectX Tool Kit
    - Samples Content Exporter
  file-extension: sdkmesh
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Mesh format used by the DirectX SDK samples (DXUT) and supported by the
  DirectX Tool Kit. The file is a set of fixed size structures (as laid
  out by MSVC with 8-byte packing) located by absolute offsets stored in
  the header: vertex buffer headers, index buffer headers, meshes,
  subsets, a frame hierarchy and materials, followed by the raw vertex
  and index buffer data.

  Version 101 uses classic materials (diffuse/normal/specular textures
  and colors); version 200 ("SDKMESH v2") reuses the same space for PBR
  materials (albedo/normal/RMA/emissive textures). Only little-endian
  files are supported by the reference loaders.

  The separate `.sdkmesh_anim` animation file is not covered.
doc-ref:
  - https://github.com/walbourn/contentexporter/wiki/SDKMESH
  - https://github.com/microsoft/DirectXTK/blob/main/Src/SDKMesh.h
  - https://github.com/microsoft/DirectXTK/blob/main/Src/ModelLoadSDKMESH.cpp
seq:
  - id: header
    type: header
instances:
  vertex_buffers:
    pos: header.ofs_vertex_stream_headers
    type: vertex_buffer_header
    repeat: expr
    repeat-expr: header.num_vertex_buffers
  index_buffers:
    pos: header.ofs_index_stream_headers
    type: index_buffer_header
    repeat: expr
    repeat-expr: header.num_index_buffers
  meshes:
    pos: header.ofs_mesh_data
    type: mesh
    repeat: expr
    repeat-expr: header.num_meshes
  subsets:
    pos: header.ofs_subset_data
    type: subset
    repeat: expr
    repeat-expr: header.num_total_subsets
  frames:
    pos: header.ofs_frame_data
    type: frame
    repeat: expr
    repeat-expr: header.num_frames
  materials:
    pos: header.ofs_material_data
    type:
      switch-on: header.version
      cases:
        200: material_v2
        _: material
    repeat: expr
    repeat-expr: header.num_materials
  ofs_buffer_data:
    value: header.len_header + header.len_non_buffer_data
    doc: Absolute offset of the buffer data section.
types:
  header:
    seq:
      - id: version
        type: u4
        valid:
          any-of: [101, 200]
      - id: is_big_endian
        type: u1
      - id: reserved1
        size: 3
      - id: len_header
        type: u8
        doc: Size of the header (104).
      - id: len_non_buffer_data
        type: u8
        doc: Size of the static data following the header.
      - id: len_buffer_data
        type: u8
        doc: Size of the vertex and index buffer data.
      - id: num_vertex_buffers
        type: u4
      - id: num_index_buffers
        type: u4
      - id: num_meshes
        type: u4
      - id: num_total_subsets
        type: u4
      - id: num_frames
        type: u4
      - id: num_materials
        type: u4
      - id: ofs_vertex_stream_headers
        type: u8
      - id: ofs_index_stream_headers
        type: u8
      - id: ofs_mesh_data
        type: u8
      - id: ofs_subset_data
        type: u8
      - id: ofs_frame_data
        type: u8
      - id: ofs_material_data
        type: u8
  vertex_element:
    doc: Direct3D 9 vertex declaration element (D3DVERTEXELEMENT9).
    seq:
      - id: stream
        type: u2
        doc: Stream index; 0xff marks the end of the declaration.
      - id: offset
        type: u2
        doc: Offset of the element within a vertex, in bytes.
      - id: type
        type: u1
        enum: decl_type
      - id: method
        type: u1
      - id: usage
        type: u1
        enum: decl_usage
      - id: usage_index
        type: u1
  vertex_buffer_header:
    seq:
      - id: num_vertices
        type: u8
      - id: len_data
        type: u8
      - id: stride
        type: u8
        doc: Size of one vertex in bytes.
      - id: decl
        type: vertex_element
        repeat: expr
        repeat-expr: 32
        doc: Vertex declaration, terminated by an element with stream 0xff.
      - id: ofs_data
        type: u8
        doc: Absolute offset of the vertex data.
    instances:
      data:
        io: _root._io
        pos: ofs_data
        size: len_data
  index_buffer_header:
    seq:
      - id: num_indices
        type: u8
      - id: len_data
        type: u8
      - id: index_type
        type: u4
        enum: index_type
      - id: reserved1
        size: 4
      - id: ofs_data
        type: u8
        doc: Absolute offset of the index data.
    instances:
      data:
        io: _root._io
        pos: ofs_data
        size: len_data
  mesh:
    seq:
      - id: name
        size: 100
        type: strz
        encoding: ASCII
      - id: num_vertex_buffers
        type: u1
      - id: reserved1
        size: 3
      - id: vertex_buffers
        type: u4
        repeat: expr
        repeat-expr: 16
        doc: Indices of the used vertex buffers; the first `num_vertex_buffers` are valid.
      - id: index_buffer
        type: u4
      - id: num_subsets
        type: u4
      - id: num_frame_influences
        type: u4
        doc: Number of bones influencing this mesh.
      - id: bounding_box_center
        type: vec3
      - id: bounding_box_extents
        type: vec3
      - id: reserved2
        size: 4
      - id: ofs_subsets
        type: u8
      - id: ofs_frame_influences
        type: u8
    instances:
      subsets:
        io: _root._io
        pos: ofs_subsets
        type: u4
        repeat: expr
        repeat-expr: num_subsets
        doc: Indices into the subset table.
      frame_influences:
        io: _root._io
        pos: ofs_frame_influences
        type: u4
        repeat: expr
        repeat-expr: num_frame_influences
        if: num_frame_influences > 0
        doc: Indices of the frames (bones) influencing this mesh.
  subset:
    seq:
      - id: name
        size: 100
        type: strz
        encoding: ASCII
      - id: material_id
        type: u4
      - id: primitive_type
        type: u4
        enum: primitive_type
      - id: reserved1
        size: 4
      - id: index_start
        type: u8
      - id: index_count
        type: u8
      - id: vertex_start
        type: u8
      - id: vertex_count
        type: u8
  frame:
    seq:
      - id: name
        size: 100
        type: strz
        encoding: ASCII
      - id: mesh
        type: u4
        doc: Index of the mesh attached to this frame, or 0xffffffff.
      - id: parent_frame
        type: u4
      - id: child_frame
        type: u4
      - id: sibling_frame
        type: u4
      - id: matrix
        type: f4
        repeat: expr
        repeat-expr: 16
        doc: 4x4 transformation matrix, row-major.
      - id: animation_data_index
        type: u4
  material:
    doc: Classic material (version 101).
    seq:
      - id: name
        size: 100
        type: strz
        encoding: ASCII
      - id: material_instance_path
        size: 260
        type: strz
        encoding: ASCII
      - id: diffuse_texture
        size: 260
        type: strz
        encoding: ASCII
      - id: normal_texture
        size: 260
        type: strz
        encoding: ASCII
      - id: specular_texture
        size: 260
        type: strz
        encoding: ASCII
      - id: diffuse
        type: vec4
      - id: ambient
        type: vec4
      - id: specular
        type: vec4
      - id: emissive
        type: vec4
      - id: power
        type: f4
      - id: reserved
        size: 48
        doc: Space for run-time pointers.
  material_v2:
    doc: PBR material (version 200).
    seq:
      - id: name
        size: 100
        type: strz
        encoding: ASCII
      - id: rma_texture
        size: 260
        type: strz
        encoding: ASCII
        doc: Roughness/metalness/ambient occlusion texture (glTF channel order).
      - id: albedo_texture
        size: 260
        type: strz
        encoding: ASCII
      - id: normal_texture
        size: 260
        type: strz
        encoding: ASCII
      - id: emissive_texture
        size: 260
        type: strz
        encoding: ASCII
      - id: alpha
        type: f4
      - id: reserved1
        size: 64
        doc: 60 reserved bytes plus 4 bytes of alignment padding.
      - id: reserved2
        size: 48
        doc: Space for run-time pointers.
  vec3:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4
  vec4:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4
      - id: w
        type: f4
enums:
  primitive_type:
    0: triangle_list
    1: triangle_strip
    2: line_list
    3: line_strip
    4: point_list
    5: triangle_list_adj
    6: triangle_strip_adj
    7: line_list_adj
    8: line_strip_adj
    9: quad_patch_list
    10: triangle_patch_list
  index_type:
    0: bits_16
    1: bits_32
  decl_type:
    0: float1
    1: float2
    2: float3
    3: float4
    4: d3dcolor
    5: ubyte4
    8: ubyte4n
    10: short4n
    14: dec3n
    15: float16_2
    16: float16_4
    17: unused
    56: dxgi_r10g10b10a2_unorm
    58: dxgi_r11g11b10_float
    63: dxgi_r8g8b8a8_snorm
  decl_usage:
    0: position
    1: blendweight
    2: blendindices
    3: normal
    5: texcoord
    6: tangent
    7: binormal
    10: color
