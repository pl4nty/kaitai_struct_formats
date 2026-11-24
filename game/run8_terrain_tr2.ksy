# Imported from https://github.com/Puyodead1/Run8-V3-reverse-engineering/blob/9695472b0729acbd1bb8a0ebcaddb01f91f40b76/misc/ksy/ksy/tr2.ksy
meta:
  id: run8_terrain_tr2
  title: TR2 Terrain Tile
  application: Run8 Train Simulator
  file-extension: tr2
  license: LicenseRef-All-Rights-Reserved
  imports:
    - run8_common
  endian: le
seq:
  - id: texture_1
    type: run8_common::cs_string
  - id: texture_2
    type: run8_common::cs_string
  - id: texture_3
    type: run8_common::cs_string
  - id: texture_4
    type: run8_common::cs_string
  - id: chunks
    type: chunk_row
    repeat: expr
    repeat-expr: 25
    doc: d:Tile X; Tiles are 25x25 chunks
  - id: lon_east
    type: f4
  - id: lon_west
    type: f4
  - id: lat_north
    type: f4
  - id: lat_south
    type: f4
types:
  chunk_row:
    seq:
      - id: chunks
        type: chunk
        repeat: expr
        repeat-expr: 25
        doc: d:Tile Y; Tiles are 25x25 chunks
  chunk:
    seq:
      - id: chunk_size
        type: u4
        doc: d:Number of elevation points in this chunk
      - id: elevations_row
        type: elevation_col
        repeat: expr
        repeat-expr: chunk_size
        doc: d:Chunk X
  elevation_col:
    seq:
      - id: elevation
        type: f4
        repeat: expr
        repeat-expr: _parent.chunk_size
        doc: d:Chunk Y
