# Imported from https://github.com/Wargus/stargus/blob/b6b90dceb7d327909987580d680b8241bedd568b/src/kaitai/tileset_dddata_bin.ksy
# Licence and copyright: see _community/README.md
meta:
  id: starcraft_tileset_dddata_bin
  title: StarCraft tileset dddata.bin (doodads)
  license: GPL-2.0-only
  endian: le
  bit-endian: le
  
seq:
  - id: doodad
    type: doodad_type
    repeat: eos

types:
  doodad_type:
    seq:
      - id: placing
        type: u2
        repeat: expr
        repeat-expr: 512
