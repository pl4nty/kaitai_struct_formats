# Imported from https://github.com/burnsba/getools/blob/6450b11ff244323536189e49522f77a6d7c9f128/Getools/Getools.Lib/Kaitai/Schema/gbivtx.ksy
# Licence and copyright: see _community/README.md
meta:
  id: goldeneye_gbi_vtx
  file-extension: bin
  license: GPL-3.0-only
  endian: be
  
seq:
  - id: verteces
    type: vtx
    repeat: eos

types:
  dummy:
    seq:
      - id: ignore
        type: u1
  vtx:
    seq:
      - id: ob
        type: coord3d_short
      - id: flag
        type: u2
      - id: texture_coord
        type: texture_coord
      - id: normal
        type: texture_normal
      - id: alpha
        type: u1
        
  coord3d_short:
    seq:
      - id: x
        type: s2
      - id: y
        type: s2
      - id: z
        type: s2
        
  texture_coord:
    seq:
      - id: u
        type: s2
      - id: v
        type: s2
  
  texture_normal:
    seq:
      - id: x
        type: s1
      - id: y
        type: s1
      - id: z
        type: s1
