# Imported from https://github.com/Metin2-Dev/wiki-beta/blob/d1dbca9140bf826045048e8e5216c650ba72c240/docs/pages/Topics/Formats/Map/Chunk/files/attributes.ksy
meta:
  id: metin2_chunk_attributes
  title: Chunk Attributes Map Format
  file-extension: atr
  license: LicenseRef-All-Rights-Reserved
  endian: le


seq:
  - id: header
    type: header
  
  - id: coordinates
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
    
  coordinate:
    seq:
      - id: walk
        type: b1
      - id: water
        type: b1
      - id: battle
        type: b1
      - id: empty1
        type: b1
      - id: empty2
        type: b1
      - id: empty3
        type: b1
      - id: empty4
        type: b1
      - id: build
        type: b1
      
    
