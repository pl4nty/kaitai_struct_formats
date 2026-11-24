meta:
  id: nulib_tex
  title: Namco Texture Archive
  application: Games with Namco NU library
  file-extension: tex
  license: MIT
  imports:
    - nulib_xmd
    - nulib_nut
seq:
  - id: xmd
    type: nulib_xmd
instances:
  textures:
    io: _root._io
    type: texture(_index)
    repeat: expr
    repeat-expr: xmd.header.count

types:
  texture:
    params:
      - id: i
        type: s4
    instances:
      id:
        value: _root.xmd.item_ids[i]
      len_nut:
        value: _root.xmd.lengths[i]
      nut:
        pos: _root.xmd.positions[i]
        size: len_nut
        type: nulib_nut
