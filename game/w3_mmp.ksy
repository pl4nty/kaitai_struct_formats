# Imported from https://github.com/WaterKnight/Warcraft3-Formats-KaitaiStruct/blob/cdd07826b18f9ec34dfa97c77eb2ff65833f9ddf/w3-mmp.ksy
meta:
  id: w3_mmp
  title: Warcraft III minimap icons (war3map.mmp)
  file-extension: mmp
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: version
    type: u4
  - id: icons_chunk
    type: icons_chunk
types:
  icons_chunk:
    seq:
      - id: num_icon
        type: u4
      - id: icon
        type: icon
        repeat: expr
        repeat-expr: num_icon
  icon:
    seq:
      - id: icon_type
        type: u4
        enum: icon_type
      - id: x
        type: u4
      - id: 'y'
        type: u4
      - id: color
        type: color
  color:
    seq:
      - id: blue
        type: u1
      - id: green
        type: u1
      - id: red
        type: u1
      - id: alpha
        type: u1
enums:
  icon_type:
    0: gold_mine
    1: house
    2: player_start
    3: neutral
    4: neutral_small
