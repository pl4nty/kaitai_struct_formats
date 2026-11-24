# Imported from https://github.com/Skullgirls-Communitys-Cut/Templates/blob/8f3bd2076d7f996f21e1454c054e1bd39d8b80c6/Kaitai/gbs.ksy
meta:
  id: skullgirls_gbs
  title: Skullgirls GBS file
  file-extension: gbs
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: gbsc_header
    size: 4
    type: str
    encoding: ASCII
  - id: file_size
    type: u4
  - id: data_version
    size: 4
  - id: scene_id
    type: u4
  - id: fonts_count
    type: u4
  - id: textures_count
    type: u4
  - id: sounds_count
    type: u4
  - id: views_count
    type: u4
  - id: messages_count
    type: u4
  - id: unknow_count
    type: u4
  - id: textures_offset
    type: u4
  - id: sounds_offset
    type: u4
  - id: view_offset
    type: u4
  - id: messages_offset
    type: u4
  - id: fonts
    type: font
    repeat: expr
    repeat-expr: fonts_count
  - id: textures
    type: texture
    repeat: expr
    repeat-expr: textures_count
  
types:
  font:
    seq:
      - id: gfnt_lable
        size: 4
        type: str
        encoding: ASCII
      - id: font_lenght
        type: u4
      - id: font_id
        type: u4
      - id: font_name
        size: 64
        type: str
        encoding: ASCII
      - id: font_size
        type: u4
      - id: atlas_w
        type: u4
      - id: atlas_h
        type: u4
      - id: max_top
        type: u4
      - id: atlas_count
        type: u4
      - id: chars_count
        type: u4
      - id: chars
        type: char
        repeat: expr
        repeat-expr: chars_count
        
  char:
    seq:
      - id: char_code
        size: 4
        type: str
        encoding: ASCII
      - id: is_image_glyph
        type: u4
      - id: char_x_offset
        type: u4
      - id: char_y_offset
        type: u4
      - id: char_w
        type: u4
      - id: char_h
        type: u4
      - id: char_top
        type: u4
      - id: char_advance
        type: u4
      - id: char_left_bearning
        type: u4
      - id: char_atlas_index
        type: u4
        
  texture:
    seq:
      - id: id
        type: u4
      - id: path
        size: 260
        type: str
        encoding: ASCII
      - id: id_repeat
        type: u4
      - id: skip
        size: 16
    

  
