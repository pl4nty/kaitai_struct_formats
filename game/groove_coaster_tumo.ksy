# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/tumo.ksy
meta:
  id: groove_coaster_tumo
  title: Groove Coaster model mesh data
  license: LicenseRef-All-Rights-Reserved
  imports:
    - groove_coaster_byte_container
  endian: be
doc: |
  Recovered from MtxModelData::LoadModelData. The format contains texture
  references, point arrays, render layers, explicit wireframe edges, and a
  bone hierarchy for each mesh. MtxModelControl::BuildVertexData confirms that
  layer records contain polygon/line primitives rather than animation data.
seq:
  - id: num_meshes
    type: u4
  - id: meshes
    type: mesh
    repeat: expr
    repeat-expr: num_meshes
types:
  mesh:
    seq:
      - id: num_textures
        type: u4
      - id: texture_names
        type: groove_coaster_byte_container
        repeat: expr
        repeat-expr: num_textures
      - id: num_points
        type: u4
      - id: points
        type: vector3
        repeat: expr
        repeat-expr: num_points
      - id: bounds
        type: f4
        repeat: expr
        repeat-expr: 8
      - id: num_layers
        type: u4
      - id: layers
        type: model_layer
        repeat: expr
        repeat-expr: num_layers
      - id: num_line_segments
        type: u4
      - id: line_segments
        type: line_segment
        repeat: expr
        repeat-expr: num_line_segments
      - id: num_bones
        type: u4
      - id: bones
        type: bone
        repeat: expr
        repeat-expr: num_bones
  vector3:
    seq:
      - { id: x, type: f4 }
      - { id: y, type: f4 }
      - { id: z, type: f4 }
  model_layer:
    seq:
      - id: primitive_type
        type: u4
        enum: primitive_types
      - id: texture_index
        type: s4
        doc: -1 means that the layer has no texture/UV stream.
      - id: num_output_vertices
        type: u4
        doc: |
          Vertex count after triangulation. A quad contributes six vertices,
          a triangle three, and a line segment two.
      - id: num_primitives
        type: u4
      - id: primitives
        type: primitive
        repeat: expr
        repeat-expr: num_primitives
  primitive:
    seq:
      - id: num_vertices
        type: u4
      - id: vertices
        type: primitive_vertex
        repeat: expr
        repeat-expr: num_vertices
  primitive_vertex:
    seq:
      - { id: point_index, type: u4 }
      - { id: u, type: f4 }
      - { id: v, type: f4 }
  line_segment:
    seq:
      - { id: point_a, type: u4 }
      - { id: point_b, type: u4 }
  bone:
    seq:
      - { id: name, type: groove_coaster_byte_container }
      - id: parent_index
        type: s4
        doc: -1 identifies a root bone.
      - id: num_children
        type: u4
      - id: children
        type: u4
        repeat: expr
        repeat-expr: num_children
      - id: num_keys
        type: u4
      - id: keys
        type: bone_key
        repeat: expr
        repeat-expr: num_keys
      - id: post_rotation_hpb
        type: vector3
        doc: Additional heading/pitch/bank rotation applied after scene motion.
      - id: rotation_hpb
        type: vector3
      - id: scale
        type: vector3
      - id: translation
        type: vector3
        doc: The loader negates the Y component when constructing runtime SRT.
  bone_key:
    seq:
      - { id: frame, type: u4 }
      - { id: value, type: f4 }
enums:
  primitive_types:
    0: polygon_faces
    1: line_segments
