# Imported from https://github.com/Wargus/stargus/blob/b6b90dceb7d327909987580d680b8241bedd568b/src/kaitai/tileset_vf4.ksy
meta:
  id: starcraft_tileset_vf4
  title: StarCraft tileset VF4 (minitile flags)
  license: GPL-2.0-only
  endian: le
  bit-endian: le
  
seq:
  - id: elements
    type: minitile
    repeat: eos

types:
  minitile:
    seq:
      - id: flags
        type: minitile_flags_types
        repeat: expr
        repeat-expr: 16
        
  minitile_flags_types:
    seq:
      - id: flags_raw
        type: u2
        
    instances:
      walkable:
        value: flags_raw & 0x01
        
      mid_elevation:
        value: flags_raw & 0x02
        
      high_elevation:
        value: flags_raw & 0x04
        
      blocks_view:
        value: flags_raw & 0x08
        
      ramp:
        value: flags_raw & 0x10
        
