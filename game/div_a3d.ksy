# Imported from https://github.com/AzazelN28/div-tools/blob/188127dfc552063452ff8e092511e6ab77d74823/formats/a3d.ksy
meta:
  id: div_a3d
  title: DIV Games Studio animated 3D object (.a3d)
  file-extension: a3d
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII #cp850
  endian: le
seq:
  - id: header
    type: header
  - id: anims
    type: anim
    repeat: expr
    repeat-expr: header.n_anims
types:
  header:
    seq:
      - id: magic
        contents: ["A3D",0]
      - id: version
        type: s2
      - id: n_objects
        type: s2
      - id: n_anims
        type: s2
      - id: dummy
        type: s2
  anim:
    seq:
      - id: offset
        type: s4
      - id: n_frames
        type: s2
      - id: dummy
        type: s2
    instances:
      frames:
        pos: offset
        type: frame
        repeat: expr
        repeat-expr: n_frames
    types:
      frame:
        seq:
          - id: matrices
            type: matrix
            repeat: expr
            repeat-expr: _root.header.n_objects
      matrix:
        seq:
          - id: v
            type: f4
            repeat: expr
            repeat-expr: 16
