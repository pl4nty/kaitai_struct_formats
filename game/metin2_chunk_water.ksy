# Imported from https://github.com/Metin2-Dev/wiki-beta/blob/d1dbca9140bf826045048e8e5216c650ba72c240/docs/pages/Topics/Formats/Map/Chunk/files/water.ksy
meta:
  id: metin2_chunk_water
  title: Chunk Water Map Format
  file-extension: wtr
  license: LicenseRef-All-Rights-Reserved
  endian: le


seq:
  - id: header
    type: header
  - id: heights
    type: coordinate
    repeat: eos

types:
  header:
    seq:
      - id: identifier
        type: u2
      - id: width
        type: u2
      - id: height
        type: u2
      - id: enabled
        type: u1
      
    
  coordinate:
    seq:
      - id: height
        type: u4
      
    
  
