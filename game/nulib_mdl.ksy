meta:
  id: nulib_mdl
  title: Namco 3D Model Archive
  application: Games with Namco NU library
  file-extension: mdl
  license: MIT
  imports:
    - nulib_xmd
    - nulib_nud
seq:
  - id: xmd
    type: nulib_xmd
instances:
  models:
    io: _root._io
    type: model(_index)
    repeat: expr
    repeat-expr: xmd.header.count

types:
  model:
    params:
      - id: i
        type: s4
    instances:
      id:
        value: _root.xmd.item_ids[i]
      len_nud:
        value: _root.xmd.lengths[i]
      nud:
        pos: _root.xmd.positions[i]
        size: len_nud
        type: nulib_nud
