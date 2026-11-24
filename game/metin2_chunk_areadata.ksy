# Imported from https://github.com/Metin2-Dev/wiki-beta/blob/d1dbca9140bf826045048e8e5216c650ba72c240/docs/pages/Topics/Formats/Map/Chunk/files/area.ksy
meta:
  id: metin2_chunk_areadata
  title: Chunk Area Data Map Format
  file-extension: adm
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: header
    type: header
  - id: objects
    type: object
    repeat: eos
    
  
types:
  header:
    seq:
      - id: object_count
        type: u2
  object:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
      - id: crc32
        type: u4
      - id: pitch
        type: f4
      - id: yaw
        type: f4
      - id: roll
        type: f4
      - id: height
        type: f4
      
    
      
