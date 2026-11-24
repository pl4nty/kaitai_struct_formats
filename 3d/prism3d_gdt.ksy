# Imported from https://github.com/Game3DEE/cmm/blob/83b3d15e2b6615c0a1ffbeef568c40baeb84f136/src/kaitai/prism3d_gdt.ksy
meta:
  id: prism3d_gdt
  title: Prism3D map model format
  file-extension: gdt
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: le

seq:
  - id: magic
    contents: "GEOM"
  - id: version
    size: 4
    type: str
  - id: model_count
    type: u4
  - id: models
    type: model
    repeat: expr
    repeat-expr: 13 # model_count

types:
  model:
    seq:
      - id: flags
        type: u4
      - id: block_s1
        type: s2
      - id: block_index
        type: s2
      - id: block_zero1
        type: u4
      - id: block_float1
        type: f4
      - id: block_float2
        type: f4
      - id: block_float3
        type: f4
      - id: block_float4
        type: f4
      - id: vertex_count
        type: u2
      - id: index_count
        type: u2
      - id: indices
        type: u2
        repeat: expr
        repeat-expr: index_count
      - id: vertices
        type: vector3f
        repeat: expr
        repeat-expr: vertex_count
      - id: colors
        type: u4
        repeat: expr
        repeat-expr: vertex_count
      - id: uvs
        type: uv
        repeat: expr
        repeat-expr: vertex_count
      - id: xyzr_5d
        type: f4
        repeat: expr
        repeat-expr: 4
        if: flags == 0x5d
      - id: extra_7d
        type: f4
        repeat: expr
        repeat-expr: 9
        if: flags == 0x7d

  uv:
    seq:
      - id: vector
        type: vector3f
        if: _parent.flags != 0x5d
      - id: u
        type: f4
      - id: v
        type: f4

  vector3f:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
