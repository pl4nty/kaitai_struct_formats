# Imported from https://github.com/Game3DEE/cmm/blob/83b3d15e2b6615c0a1ffbeef568c40baeb84f136/src/kaitai/serious1_bs.ksy
meta:
  id: serious1_bs
  title: Serious Engine 1 skeleton (.bs)
  file-extension: bs
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: le

seq:
  - id: magic
    contents: "SKEL"
  - id: version
    type: u4
  - id: lod_count
    type: u4
  - id: lods
    type: lod
    repeat: expr
    repeat-expr: lod_count

types:
  lod:
    seq:
      - id: sfn_len
        type: u4
      - id: source_filename
        size: sfn_len
        type: str
      - id: max_distance
        type: f4
      - id: bone_count
        type: u4
      - id: bones
        type: bone
        repeat: expr
        repeat-expr: bone_count
        
  bone:
    seq:
      - id: nl
        type: u4
      - id: name
        size: nl
        type: str
      - id: pl
        type: u4
      - id: parent
        size: pl
        type: str
      - id: abs_placement_matrix
        type: f4
        repeat: expr
        repeat-expr: 12
      - id: relative_placement
        type: qvect
      - id: offset_length
        type: f4
      - id: bone_length
        type: f4

  qvect:
    seq:
      - id: pos
        type: vector3f
      - id: rot
        type: quaternion

  vector3f:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
        
  quaternion:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
      - id: w
        type: f4
