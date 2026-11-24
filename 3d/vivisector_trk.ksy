# Imported from https://github.com/Game3DEE/cmm/blob/83b3d15e2b6615c0a1ffbeef568c40baeb84f136/src/kaitai/vivisector_trk.ksy
meta:
  id: vivisector_trk
  file-extension: vivisector_trk
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII
  endian: le

seq:
  - id: bone_count
    type: u4
  - id: frame_max
    type: u4
  - id: rot_sequence
    type: u4
    doc: Either 1 or zero, any other value gets set to 0 in code
  - id: fps
    type: u4
  - id: bones
    type: bone
    repeat: expr
    repeat-expr: bone_count

types:
  bone:
    seq:
      - id: name
        size: 32
        type: strz
      - id: count
        type: u4
      - id: blocks
        type: block
        repeat: expr
        repeat-expr: count
  
  block:
    seq:
      - id: frame_index
        type: u4
      - id: active
        type: u4
      - id: acceleration
        type: u4
      - id: rotation
        type: vector3f
        doc: y rotation gets * -1 on load
      - id: translation
        type: vector3f
      - id: scale
        type: vector3f
        doc: scale

  vector3f:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
