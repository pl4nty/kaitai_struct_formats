# Imported from https://github.com/Wargus/stargus/blob/b6b90dceb7d327909987580d680b8241bedd568b/src/kaitai/tileset_cv5.ksy
meta:
  id: starcraft_tileset_cv5
  title: StarCraft tileset CV5 (tile groups)
  license: GPL-2.0-only
  endian: le
  bit-endian: le
  
seq:
  - id: elements
    type: group
    repeat: eos

types:
  group:
    seq:
      - id: doodad
        type: u2

      - id: ground
        type: ground_nibbles
        
      - id: unknown1
        type: u2
        
      - id: unknown2
        type: u2
        
      - id: unknown3
        type: u2
        
      - id: unknown4
        type: u2
        
      - id: unknown5
        type: u2
        
      - id: unknown6
        type: u2
        
      - id: unknown7
        type: u2
        
      - id: unknown8
        type: u2
        
      - id: megatile_references
        type: u2
        repeat: expr
        repeat-expr: 16
        
  ground_nibbles:
    seq:
      - id: buildable
        type: b4
        
      - id: ground_type
        type: b4
        
      - id: unknown1
        type: b4
        
      - id: ground_height
        type: b4
        
