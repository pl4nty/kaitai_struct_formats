# Imported from https://github.com/Game3DEE/darkstone/blob/afc3261693b91fcd371e975889d788dfded04311/src/kaitai/obj3d.ksy
# Licence and copyright: see _community/README.md
meta:
  id: darkstone_obj3d_dat
  file-extension: dat
  license: MIT
  encoding: UTF-8
  endian: le

seq:
  - contents: [ 1, 0 ]
  - id: count
    type: u4
  - id: objects
    type: object3d
    repeat: expr
    repeat-expr: count

types:
  object3d:
    seq:
      - contents: [ 1, 0 ]
      - id: name
        size: 32
        type: strz
        doc: name of o3d file in data/common/meshes directory.
    
