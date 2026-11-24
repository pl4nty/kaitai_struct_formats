# Imported from https://github.com/Puyodead1/Run8-V3-reverse-engineering/blob/9695472b0729acbd1bb8a0ebcaddb01f91f40b76/misc/ksy/ksy/avatar.ksy
meta:
  id: run8_avatar
  title: Avatar File
  application: Run8 Train Simulator V3
  file-extension: rn8
  license: LicenseRef-All-Rights-Reserved
  imports:
    - run8_common
  endian: le
doc: "There are currently 3 avatars:\n
  - Brian\n
  - Chris\n
  - Pablo\n
  \n\n
  Avatar files are 3D model files with the `rn8` file extension. Model units are in centimeters."
seq:
  - id: vertex_count
    type: s4
    doc: d:Divide by 7
  - id: vertices
    type: vertex_struct
    repeat: expr
    repeat-expr: num_vertices
  - id: texture_count
    type: s4
    doc: d:Add 6
  - id: textures
    type: run8_common::cs_string
    repeat: expr
    repeat-expr: num_textures
  - id: is_ushort_index_buffer
    type: run8_common::boolean
    doc: d:True if the indices are stored as ushorts
  - id: num_index_buffer
    type: s4
  - id: ushort_index_buffer
    type: u2
    repeat: expr
    repeat-expr: num_index_buffer
    if: is_ushort_index_buffer.is_true
    doc: c:Only if the index buffer is ushort
  - id: index_buffer
    type: s4
    repeat: expr
    repeat-expr: num_index_buffer
    if: is_ushort_index_buffer.is_false
    doc: c:Only if the index buffer is not ushort
  - id: num_unknown_structs
    type: s4
    doc: d:Subtract 9
  - id: unknown_structs
    type: unknown_struct
    repeat: expr
    repeat-expr: num_unknown_struct_altered
  - id: num_skeleton_hierarchy
    type: s4
  - id: skeleton_hierarchy
    type: s4
    repeat: expr
    repeat-expr: num_skeleton_hierarchy
  - id: num_bone_indices
    type: s4
  - id: bone_indices
    type: bone_index_struct
    repeat: expr
    repeat-expr: num_bone_indices
  - id: num_bind_poses
    type: s4
  - id: bind_poses
    type: run8_common::matrix4
    repeat: expr
    repeat-expr: num_bind_poses
  - id: num_inverse_bind_poses
    type: s4
  - id: inverse_bind_poses
    type: run8_common::matrix4
    repeat: expr
    repeat-expr: num_inverse_bind_poses
  - id: num_animations
    type: s4
    doc: d:Seems to always be 16
  - id: animations
    type: animation_clip
    repeat: expr
    repeat-expr: num_animations
instances:
  num_vertices:
    value: vertex_count / 7
  num_textures:
    value: texture_count + 6
  num_unknown_struct_altered:
    value: num_unknown_structs - 9
types:
  vertex_struct:
    seq:
      - id: reserved1
        type: f4
      - id: position_x
        type: f4
        doc: d:Multiply by 63.7f
      - id: normal_y
        type: f4
        doc: d:Divide by -1.732f
      - id: position_z
        type: f4
        doc: d:Divide by 16f
      - id: tex_coord_x
        type: f4
        doc: d:Divide by 4.8f
      - id: normal_x
        type: f4
        doc: d:Divide by 10.962f
      - id: reserved2
        type: f4
      - id: normal_z
        type: f4
        doc: d:Divide by 11.432f
      - id: tex_coord_y
        type: f4
        doc: d:Divide by 9.6f
      - id: position_y
        type: f4
        doc: d:Multiply by 6f
      - id: blend_index_w
        type: u1
      - id: blend_weight_z
        type: f4
      - id: blend_index_x
        type: u1
      - id: blend_weight_y
        type: f4
      - id: blend_index_y
        type: u1
      - id: blend_weight_w
        type: f4
      - id: blend_idex_z
        type: u1
      - id: blend_weight_x
        type: f4
  unknown_struct:
    seq:
      - id: reserved
        type: s4
      - id: texture_index
        type: s4
        doc: c:`_mrao` is appended to the texture name
      - id: num_index_buffer
        type: s4
      - id: start_index_location
        type: s4
      - id: base_vertex_location
        type: s4
  bone_index_struct:
    seq:
      - id: key
        type: run8_common::cs_string
      - id: bone_index
        type: s4
  animation_clip:
    seq:
      - id: clip_name
        type: run8_common::cs_string
      - id: duration
        type: f8
        doc: d:Duration in ms
      - id: num_keyframes
        type: s4
      - id: keyframes
        type: animation_keyframe
        repeat: expr
        repeat-expr: num_keyframes
  animation_keyframe:
    seq:
      - id: bone_index
        type: s4
      - id: time
        type: f8
      - id: transform
        type: run8_common::matrix4
