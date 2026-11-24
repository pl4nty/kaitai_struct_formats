# Imported from https://github.com/Game3DEE/darkstone/blob/afc3261693b91fcd371e975889d788dfded04311/src/kaitai/trisprite.ksy
# Licence and copyright: see _community/README.md
meta:
  id: darkstone_trisprite_dat
  file-extension: dat
  license: MIT
  encoding: UTF-8
  endian: le

seq:
  - contents: [ 1, 0 ]
  - id: count
    type: u4
  - id: sprites
    type: sprite
    repeat: expr
    repeat-expr: count

types:
  sprite:
    seq:
      - contents: [ 1, 0 ]
      - id: name
        size: 32
        type: strz
      - id: x_pos
        type: u2
      - id: y_pos
        type: u2

      #Source image from DATA\BANKDATABASE\DRAGONBLADE\
      - id: source_image_number
        type: u2

      #A collision(where the player can click) box with dimension 24x24 pixels.
      #Valid values [0x00..0x05]
      #0x00=1x1, 0x01=1x3, 0x02=2x2, 0x03=2x3, 0x04=3x3, 0x05=1x2
      - id: size_collision
        type: u2

      - id: size_sprite
        type: u2
      - id: opacity
        type: u4
