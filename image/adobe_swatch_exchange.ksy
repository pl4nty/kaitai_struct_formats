# Imported from https://github.com/1j01/anypalette.js/blob/eaf17cca78203bf2e68298137859f3f23cc46520/src/formats/ksy/ase.ksy
# Licence and copyright: see _community/README.md
meta:
  id: adobe_swatch_exchange
  application:
    - Adobe Photoshop
    - Adobe InDesign
    - Adobe Illustrator
  file-extension: ase
  xref:
    wikidata: Q27979314
  tags:
    - color
    - palette
  license: CC0-1.0
  endian: be
doc: Adobe Swatch Exchange is a format for exchanging color palettes.
seq:
  - id: magic
    contents: "ASEF"
  - id: version
    type: u4
  - id: number_of_blocks
    type: u4
  - id: blocks
    type: block
    repeat: expr
    repeat-expr: number_of_blocks
types:
  block:
    seq:
      - id: type
        type: u2
        enum: block_type
      - id: length
        type: u4
      - id: body
        size: length
        type:
          switch-on: type
          cases:
            'block_type::group_start': group_start
            'block_type::group_end': group_end
            'block_type::color': color
  group_end:
    seq: []
  group_start:
    seq:
      - id: name_length
        type: u2
        doc: Length in codepoints, including a null terminator
      - id: name
        size: (name_length - 1) * 2
        type: str
        encoding: UTF-16BE
      - id: name_terminator
        contents: [0x00, 0x00]
  color:
    seq:
      - id: name_length
        type: u2
        doc: Length in codepoints, including a null terminator
      - id: name
        size: (name_length - 1) * 2
        type: str
        encoding: UTF-16BE
      - id: name_terminator
        contents: [0x00, 0x00]
      - id: color_space
        size: 4
        type: str
        encoding: ASCII
      - id: color_data
        type:
          switch-on: color_space
          cases:
            '"RGB "': rgb_color
            '"CMYK"': cmyk_color
            '"GRAY"': grayscale_color
      - id: color_mode
        type: u2
        enum: color_mode
  rgb_color:
    seq:
      - id: red
        type: f4
      - id: green
        type: f4
      - id: blue
        type: f4
  cmyk_color:
    seq:
      - id: cyan
        type: f4
      - id: magenta
        type: f4
      - id: yellow
        type: f4
      - id: black
        type: f4
  grayscale_color:
    seq:
      - id: lightness
        type: f4
enums:
  block_type:
    0xc001: group_start
    0xc002: group_end
    0x0001: color
  color_mode:
    0: global
    1: spot
    2: normal
