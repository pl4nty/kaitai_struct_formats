# Imported from https://github.com/AzazelN28/div-tools/blob/188127dfc552063452ff8e092511e6ab77d74823/formats/o3d.ksy
meta:
  id: div_o3d
  title: DIV Games Studio 3D object (.o3d)
  file-extension: o3d
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII #cp850
  endian: le
seq:
  - id: header
    type: header
instances:
  objects:
    pos: header.offset_objs
    type: obj
    repeat: expr
    repeat-expr: header.n_objects
  materials:
    pos: header.offset_mats
    type: material
    repeat: expr
    repeat-expr: header.n_materials
  dummies:
    pos: header.offset_dummies
    type: bbox
    repeat: expr
    repeat-expr: header.n_dummies
  tapes:
    pos: header.offset_tapes
    type: tape
    repeat: expr
    repeat-expr: header.n_tapes
  frames:
    pos: header.offset_anms
    type: frame
    repeat: expr
    repeat-expr: header.n_frames
types:
  header:
    seq:
      - id: magic
        contents: ["O3D",0]
      - id: version
        type: s2
      - id: n_objects
        type: s2
      - id: n_materials
        type: s2
      - id: n_dummies
        type: s2
      - id: n_tapes
        type: s2
      - id: n_frames
        type: s2
      - id: offset_objs
        type: s4
      - id: offset_mats
        type: s4
      - id: offset_dummies
        type: s4
      - id: offset_tapes
        type: s4
      - id: offset_anms
        type: s4
      - id: bbox
        type: bbox
  vector:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
  rgb:
    seq:
      - id: r
        type: f4
      - id: g
        type: f4
      - id: b
        type: f4
  bbox:
    seq:
      - id: v1
        type: vector
      - id: v2
        type: vector
  vertex:
    seq:
      - id: pos
        type: vector
      - id: normal
        type: vector
      - id: u
        type: f4
      - id: v
        type: f4
  face:
    seq:
      - id: v0
        type: s2
      - id: v1
        type: s2
      - id: v2
        type: s2
      - id: mat_idx
        type: s2
  obj:
    seq:
      - id: n_vertices
        type: s2
      - id: n_faces
        type: s2
      - id: mat_idx
        type: s2
      - id: name
        size: 20
        type: str
      - id: bbox
        type: bbox
      - id: vertices
        type: vertex
        repeat: expr
        repeat-expr: n_vertices
      - id: faces
        type: face
        repeat: expr
        repeat-expr: n_faces
  material:
    seq:
      - id: diffuse
        type: rgb
      - id: ambient
        type: rgb
      - id: specular
        type: rgb
      - id: transparency
        type: s4
      - id: texture
        size: 16
        type: str
      - id: map_type
        type: s4
        enum: map_type
    enums:
      map_type:
        0: wire
        1: flat
        2: gouraud
        3: phong
        4: metal
  tape:
    seq:
      - id: obj1
        type: s4
      - id: vert1
        type: s4
      - id: obj2
        type: s4
      - id: vert2
        type: s4
      - id: link_mode
        type: s4
  matrix:
    seq:
      - id: v
        type: f4
        repeat: expr
        repeat-expr: 16
  frame:
    seq:
      - id: matrices
        type: matrix
        repeat: expr
        repeat-expr: _root.header.n_objects
