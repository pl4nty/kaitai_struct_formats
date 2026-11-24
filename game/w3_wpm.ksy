# Imported from https://github.com/WaterKnight/Warcraft3-Formats-KaitaiStruct/blob/cdd07826b18f9ec34dfa97c77eb2ff65833f9ddf/w3-wpm.ksy
meta:
  id: w3_wpm
  file-extension: wpm
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /image/w3id
  endian: le
seq:
  - id: file_id
    type: w3id
  - id: version
    type: u4
  - id: width
    type: u4
  - id: height
    type: u4
  - id: pathing_node
    type: u1
    repeat: expr
    repeat-expr: width * height
