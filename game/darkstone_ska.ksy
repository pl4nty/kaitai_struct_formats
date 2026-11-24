# Imported from https://github.com/Game3DEE/darkstone/blob/afc3261693b91fcd371e975889d788dfded04311/src/kaitai/ska.ksy
# Licence and copyright: see _community/README.md
meta:
  id: darkstone_ska
  title: Darkstone skeleton list
  application: All DSI Darkstone versions
  file-extension: ska
  license: CC0-1.0
  encoding: UTF-8
  endian: le
doc: |
  This file format lists which bones form a skeleton as used in the animations
  in the game.

seq:
  - id: version
    contents: [ 1, 0 ]
  - id: count
    type: u4
  - id: skeletons
    type: skeleton
    repeat: expr
    repeat-expr: count

types:
  skeleton:
    seq:
      - id: version
        contents: [ 1, 0 ]
      - id: name
        size: 64
        type: strz
      - id: model_name
        size: 64
        type: strz
      - id: bones
        size: 64
        type: strz
        repeat: expr
        repeat-expr: 64
