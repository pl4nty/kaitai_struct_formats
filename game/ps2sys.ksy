# Imported from https://github.com/MightyDuke/ico2gltf/blob/6facbeaec6ca4a7a35f1239e8adf1548b333e67c/ksy/ps2sys.ksy
meta:
  id: ps2sys
  title: PlayStation 2 icon.sys file
  file-extension: sys
  license: MIT
  endian: le
seq:
  - id: magic_string
    contents: "PS2D"
  - id: reserved1
    contents: [0x0, 0x0]
  - id: offset_2nd_line
    type: u2
  - id: reserved2
    contents: [0x0, 0x0, 0x0, 0x0]
  - id: bg_opacity
    type: u4
  - id: bg_color_upperleft
    type: bg_color
  - id: bg_color_upperright
    type: bg_color
  - id: bg_color_lowerleft
    type: bg_color
  - id: bg_color_lowerright
    type: bg_color
  - id: light1_direction
    type: light_direction
  - id: light2_direction
    type: light_direction
  - id: light3_direction
    type: light_direction
  - id: light1_color
    type: light_color
  - id: light2_color
    type: light_color
  - id: light3_color
    type: light_color
  - id: light_ambient_color
    type: light_color
  - id: title
    size: 68
    type: str
    encoding: Shift_JIS
  - id: icon_file
    size: 64
    type: str
    encoding: ASCII
  - id: icon_copy_file
    size: 64
    type: str
    encoding: ASCII
  - id: icon_delete_file
    size: 64
    type: str
    encoding: ASCII
  - id: reserved3
    size: 512
types:
  bg_color:
    seq:
      - id: r
        type: u4
      - id: g
        type: u4
      - id: b
        type: u4
      - id: a
        type: u4
  light_direction:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4
      - id: w
        type: f4
  light_color:
    seq:
      - id: r
        type: f4
      - id: g
        type: f4
      - id: b
        type: f4
      - id: a
        type: f4
