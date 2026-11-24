# Imported from https://github.com/Game3DEE/darkstone/blob/afc3261693b91fcd371e975889d788dfded04311/src/kaitai/snd.ksy
meta:
  id: darkstone_snd_dat
  file-extension: dat
  license: MIT
  encoding: UTF-8
  endian: le

seq:
  - contents: [ 1, 0 ]
  - id: count
    type: u4
  - id: sounds
    type: sound
    repeat: expr
    repeat-expr: count

types:
  sound:
    seq:
      - contents: [ 1, 0 ]
      - id: name
        size: 32
        type: strz
