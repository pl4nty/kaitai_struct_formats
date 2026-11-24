# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/8_curtain.ksy
# Licence and copyright: see _community/README.md
meta:
  id: curtain
  title: 'Project Zomboid save: curtain object'
  license: MIT
  imports:
    - common
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  - id: open
    type: u1
  - id: north
    type: u1
  - id: health
    type: s4
  - id: barricade_strength
    type: s4
  # If open, the sprite read is closedSprite; otherwise it's openSprite
  # The other sprite is set from the base object's sprite
  - id: other_sprite_id
    type: s4
