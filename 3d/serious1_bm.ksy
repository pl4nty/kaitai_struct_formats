# Imported from https://github.com/Game3DEE/cmm/blob/83b3d15e2b6615c0a1ffbeef568c40baeb84f136/src/kaitai/serious1_bm.ksy
meta:
  id: serious1_bm
  file-extension: bm
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: le

seq:
  - id: magic
    contents: "MESH"
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
      - id: flags
        type: u4
      - id: vertex_count
        type: u4
      - id: vertices
        type: vertex
        repeat: expr
        repeat-expr: vertex_count
      - id: normals
        type: vertex
        repeat: expr
        repeat-expr: vertex_count
      - id: uvmap_count
        type: u4
      - id: uvmaps
        type: uvmap
        repeat: expr
        repeat-expr: uvmap_count
      - id: surface_count
        type: u4
      - id: surfaces
        type: surface
        repeat: expr
        repeat-expr: surface_count
      - id: weight_map_count
        type: u4
      - id: weight_maps
        type: weight_map
        repeat: expr
        repeat-expr: weight_map_count
      - id: morph_map_count
        type: u4
      - id: morph_maps
        type: morph_map
        repeat: expr
        repeat-expr: morph_map_count
  
  morph_map:
    seq:
      - id: name_len
        type: u4
      - id: name
        size: name_len
        type: str
      - id: is_relative
        type: u4
      - id: morph_set_count
        type: u4
      - id: morph_sets
        type: morph_set
        repeat: expr
        repeat-expr: morph_set_count

  morph_set:
    seq:
      - id: abs_vertex_index
        type: u4
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
      - id: nx
        type: f4
      - id: ny
        type: f4
      - id: nz
        type: f4
      - size: 4

  weight_map:
    seq:
      - id: name_len
        type: u4
      - id: name
        size: name_len
        type: str
      - id: weight_count
        type: u4
      - id: weights
        type: weight
        repeat: expr
        repeat-expr: weight_count

  weight:
    seq:
      - id: abs_vertex_index
        type: u4
      - id: weight
        type: f4

  surface:
    seq:
      - id: name_len
        type: u4
      - id: name
        size: name_len
        type: str
      - id: first_vertex
        type: u4
      - id: vertex_count
        type: u4
      - id: triangle_count
        type: u4
      - id: indices
        type: u4
        repeat: expr
        repeat-expr: triangle_count * 3
      - id: has_shader
        type: u4
      - id: shader
        type: shader_desc
        if : has_shader != 0

  shader_desc:
    seq:
      - id: texture_count
        type: u4
      - id: texture_coord_count
        type: u4
      - id: color_count
        type: u4
      - id: float_count
        type: u4
      - id: name_len
        type: u4
      - id: name
        size: name_len
        type: str
      - id: textures
        type: string
        repeat: expr
        repeat-expr: texture_count
      - id: texture_coord_indices
        type: u4
        repeat: expr
        repeat-expr: texture_coord_count
      - id: colors
        type: u4
        repeat: expr
        repeat-expr: color_count
      - id: floats
        type: f4
        repeat: expr
        repeat-expr: float_count
      - id: flags
        type: u4

  string:
    seq:
      - id: len
        type: u4
      - id: str
        size: len
        type: str

  uvmap:
    seq:
      - id: name_len
        type: u4
      - id: name
        size: name_len
        type: str
      - id: uvs
        type: vector2f
        repeat: expr
        repeat-expr: _parent.vertex_count
        
  vector2f:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      
  vertex:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
      - size: 4
