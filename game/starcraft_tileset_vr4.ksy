# Imported from https://github.com/Wargus/stargus/blob/b6b90dceb7d327909987580d680b8241bedd568b/src/kaitai/tileset_vr4.ksy
meta:
  id: starcraft_tileset_vr4
  title: StarCraft tileset VR4 (minitile graphics)
  license: GPL-2.0-only
  endian: le
  bit-endian: le
  
seq:
  - id: elements
    type: pixel_type
    repeat: eos

    
types:
  pixel_type:
    seq:
      - id: minitile
        size: 64
