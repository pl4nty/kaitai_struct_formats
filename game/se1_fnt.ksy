# Imported from https://github.com/zcaliptium/Serious-Engine-Formats/blob/2d50fe511b450169df49bb590b76d235a966ee2b/SE1_FNT.ksy
# Licence and copyright: see _community/README.md
# Copyright ZCaliptium 2021-2022
meta:
  id: se1_fnt
  file-extension: fnt
  license: MIT
  endian: le
seq:
  - id: magic
    contents: 'FTTF'
  - id: texture
    type: dfnm
  - id: char_width
    type: u4
  - id: char_height
    type: u4
  - id: chars
    type: font_char_data
    repeat: expr
    repeat-expr: 256
types:
  dfnm:
    seq:
      - id: magic
        contents: 'DFNM'
      - id: len
        type: u4
      - id: type
        size: len
        type: str
        encoding: ASCII
  font_char_data:
    seq:
      - id: offset_x
        type: u4
      - id: offset_y
        type: u4
      - id: start_x
        type: u4
      - id: start_y
        type: u4
