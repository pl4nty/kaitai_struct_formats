# Imported from https://github.com/Game3DEE/cmm/blob/83b3d15e2b6615c0a1ffbeef568c40baeb84f136/src/kaitai/primalprey_ssm.ksy
meta:
  id: primalprey_ssm
  file-extension: ssmo
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: le

seq:
  - id: magic
    contents: "SSMO"
  - id: version
    type: u4
  - id: vert_count
    type: u2
  - id: face_count
    type: u2
  - id: texture_count
    type: u2
  - id: frames_count
    type: u2
  - id: anim_count
    type: u2
  - id: obj_count
    type: u2
  - id: param_count
    type: u2

  - id: faces
    type: face
    repeat: expr
    repeat-expr: face_count

  - id: textures
    type: texture
    repeat: expr
    repeat-expr: texture_count

  - id: frames
    type: frame
    repeat: expr
    repeat-expr: frames_count

  - id: animations
    type: animation
    repeat: expr
    repeat-expr: anim_count

  - id: objects
    type: obj
    repeat: expr
    repeat-expr: obj_count

  - id: params
    type: param
    repeat: expr
    repeat-expr: param_count

types:
  face:
    seq:
      - id: vertices
        type: u2
        repeat: expr
        repeat-expr: 3
      - id: flags
        type: u2
      - id: uvs
        type: f4
        repeat: expr
        repeat-expr: 3 * 2
      - id: mesh_id
        type: u2
      - id: unknown
        type: u2

  texture:
    seq:
      - id: filler
        size: 4
      - id: name_len
        type: u2
      - id: name
        size: name_len
        type: str

  frame:
    seq:
      - id: filler1
        contents: [ 0,0,0,0 ]
      - id: filler2
        contents: [ 0,0,0,0 ]
      - id: name_len
        type: u2
      - id: name
        size: name_len
        type: str
      - id: per_obj
        type: u1
        repeat: expr
        repeat-expr: _root.obj_count
      - id: vertices
        type: vector3f
        repeat: expr
        repeat-expr: _root.vert_count

  animation:
    seq:
      - id: filler1
        contents: [ 0,0,0,0 ]
      - id: filler2
        contents: [ 0,0,0,0 ]
      - id: frame_count
        type: u2
      - id: name_len
        type: u2
      - id: name
        size: name_len
        type: str
      - id: frame_indices
        type: u2
        repeat: expr
        repeat-expr: frame_count
      - id: frame_durations
        type: f4
        repeat: expr
        repeat-expr: frame_count

  obj:
    seq:
      - id: filler1
        type: u4
      - id: filler2
        type: u4
      - id: name_len
        type: u2
      - id: name
        size: name_len
        type: str
      - id: skin_count
        type: u2
      - id: skins
        type: skin
        repeat: expr
        repeat-expr: skin_count
      - id: param_count
        type: u2
      - id: params
        type: param
        repeat: expr
        repeat-expr: param_count

  skin:
    seq:
      - id: texture_index
        type: u2
      - id: name_len
        type: u2
      - id: name
        size: name_len
        type: str

  param:
    seq:
      - id: filler
        contents: [ 0 ]
      - id: key_len
        type: u2
      - id: key
        size: key_len
        type: str
      - id: value_len
        type: u2
      - id: value
        size: value_len
        type: str

  vector3f:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
