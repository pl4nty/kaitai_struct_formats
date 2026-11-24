# Imported from https://github.com/CTR-tools/CTR-tools/blob/8edc826ccab49099776f6431e25b4136a2ecbec3/formats/ctr_ctr.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ctr_model
  title: Crash Team Racing (PS1) model file
  application: Crash Team Racing
  file-extension: ctr
  license: GPL-2.0-only
  endian: le

doc-ref: https://github.com/CTR-tools/CTR-tools/blob/master/formats/ctr_ctr.ksy

seq:
  - id: data_size
    type: u4
  - id: data
    size: data_size
    type: ctr_model
  - id: ptr_map_size
    type: u4
  - id: ptr_map
    type: u4
    repeat: expr
    repeat-expr: ptr_map_size / 4

types:
  ctr_model:
    seq:
      - id: name
        size: 16
        type: strz
        encoding: ASCII
      - id: thread_id # this is an internal number
        type: s2
      - id: num_meshes
        type: u2
      - id: ptr_meshes
        type: u4
    instances:
      meshes:
        pos: ptr_meshes
        type: ctr_mesh
        repeat: expr
        repeat-expr: num_meshes

  ctr_mesh:
    seq:
      - id: name
        size: 16
        type: strz
        encoding: ASCII
      - id: unk
        type: u4
      - id: lod_distance
        type: u2
      - id: billboard
        type: u2
      - id: scale
        type: vector3s
      - id: padding # assumed always 0?
        type: u2

      - id: ptr_cmd
        type: u4
      - id: ptr_verts
        type: u4
      - id: ptr_tex
        type: u4
      - id: ptr_clut
        type: u4
      - id: unk2
        type: u4
      - id: num_anims
        type: u4
      - id: ptr_anims
        type: u4
      - id: unk3
        type: u4
    instances:
      commands:
        pos: ptr_cmd
        type: command
        repeat: until
        repeat-until: _.value == 0xFFFFFFFF
      anims:
        pos: ptr_anims
        type: ctr_anim
        repeat: expr
        repeat-expr: num_anims

  ctr_anim:
    seq:
      - id: ptr
        type: u4
    instances:
      data:
        pos: ptr
        type: ctr_anim_data

  ctr_anim_data:
    seq:
      - id: name
        size: 16
        type: strz
        encoding: ASCII
      - id: num_frames_pack
        type: u2
      - id: frame_size
        type: u2
      - id: ptr_unk
        type: u4
      - id: vdata
        type: ctr_anim_frame(frame_size)
        repeat: expr
        repeat-expr: num_frames
    instances:
      interp:
        value: num_frames_pack & 0x8000 > 0
      num_frames:
        value: "interp ? (num_frames_pack & 0x7FFF) / 2 + 1 : num_frames_pack"

  ctr_anim_frame:
    params:
      - id: frame_size
        type: u4
    seq:
      - id: position
        type: vector3s
      - id: padding
        type: u2
      - id: skip
        size: 16
      - id: ptr_data
        type: u4
      - id: extra_unk
        size: ptr_data - 0x1C
      - id: data
        size: frame_size - ptr_data

  vector3s:
    seq:
      - id: x
        type: s2
      - id: y
        type: s2
      - id: z
        type: s2

  command:
    seq:
      - id: value
        type: u4be
    instances:
      new_face_block:
        value: (value & (1 << 31)) >> 31
      swap_first_vertex:
        value: (value & (1 << 30)) >> 30
      flip_face_normal:
        value: (value & (1 << 29)) >> 29
      cull_backface:
        value: (value & (1 << 28)) >> 28
      color_scratchpad:
        value: (value & (1 << 27)) >> 27
      read_vertex_stack:
        value: (value & (1 << 26)) >> 26
      unk1:
        value: (value & (1 << 25)) >> 25
      unk2:
        value: (value & (1 << 24)) >> 24
      stack_write_index:
        value: (value >> 16) & 0b11111111
      color_coord_index:
        value: (value >> 9) & 0b1111111
      tex_coord_index:
        value: value & 0b111111111
