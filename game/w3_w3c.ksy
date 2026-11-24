# Imported from https://github.com/WaterKnight/Warcraft3-Formats-KaitaiStruct/blob/cdd07826b18f9ec34dfa97c77eb2ff65833f9ddf/w3-w3c.ksy
meta:
  id: w3_w3c
  file-extension: w3c
  license: LicenseRef-All-Rights-Reserved
  imports:
    - w3str
  endian: le
seq:
  - id: version
    type: u4
  - id: num_camera
    type: u4
  - id: camera
    type: camera
    repeat: expr
    repeat-expr: num_camera
types:
  camera:
    seq:
      - id: target_x
        type: f4
      - id: target_y
        type: f4
      - id: target_z
        type: f4
      - id: angle
        type: f4
      - id: angle_of_attack
        type: f4
      - id: distance
        type: f4
      - id: roll
        type: f4
      - id: field_of_view
        type: f4
      - id: far_clipping
        type: f4
      - id: unknown
        type: f4
      - id: name
        type: w3str
