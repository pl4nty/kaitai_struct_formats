# Imported from https://github.com/OriDevTeam/lyketo/blob/bb99f7536ea12bbc74b9aa08f18afd2641bda78d/vfx/src/parsers/effect/version2/effect_data_v2.ksy
meta:
  id: metin2_effect_data_v2
  title: Effect Data Format Version 2
  file-extension: mde
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: be

seq:
  - id: magic
    contents: MDEData002
  - id: mesh_count
    type: s2
  - id: empty1 # This is here because i don't know how to consume 2 extra bytes
    type: s2
  - id: frame_count
    type: s2
  - id: empty2 # Same as the empty1 field
    type: s2
  - id: meshes
    type: mesh(frame_count)
    repeat: expr
    repeat-expr: mesh_count

types:
  mesh:
    params:
      - id: frame_count
        type: s2
    seq:
      - id: object_name
        size: 32
        type: str
      
      - id: diffuse_file_name
        size: 128
        type: str
      
      - id: frames
        type: frame
        repeat: expr
        repeat-expr: frame_count
  
  frame:
    seq:
      - id: changed
        type: u1
      - id: visibility
        type: f4
      - id: vertex_count
        type: u4
      - id: index_count
        type: u4
      - id: texture_vertex_count
        type: u4
      
      - id: axis_vectors
        type: v3_axis
        repeat: expr
        repeat-expr: 1
        #repeat-expr: vertex_count
        
      - id: index_vectors
        type: u4
        repeat: expr
        repeat-expr: 1
        #repeat-expr: index_count
        
      - id: texture_vertices_vectors
        type: v2_axis
        repeat: expr
        repeat-expr: 1
        #repeat-expr: texture_vertex_count
        
      - id: texture_index_vectors
        type: u4
        repeat: expr
        repeat-expr: 1
        #repeat-expr: index_count
      
  
  v2_axis:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
  
  v3_axis:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
  
