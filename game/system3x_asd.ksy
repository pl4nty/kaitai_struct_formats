# Imported from https://gist.github.com/kichikuou/e80b96fdc8184166c02c674ade907f4f
meta:
  id: system3x_asd
  title: System 3.x save file
  application: Games based on AliceSoft's System 3.x engine
  file-extension: asd
  license: CC0-1.0
  encoding: Shift_JIS
  endian: le
doc: Save file format used in System 3.6 - 3.9 game engines and xsystem35.
seq:
  - id: magic
    size: 32
    type: strz
  - id: version
    type: u4
  - id: game_name  # unused?
    size: 28
    type: strz
  - id: sel
    type: text_attrs
  - id: msg
    type: text_attrs
  - id: reserved1
    size: 8
  - id: sco_page
    type: u4
  - id: sco_index
    type: u4
  - id: reserved2
    size: 8
  - id: sel_win_info
    type: rectangle_w
    repeat: expr
    repeat-expr: 128
  - id: msg_win_info
    type: rectangle_w
    repeat: expr
    repeat-expr: 128
  - id: stack_info
    type: stack
  - id: var_str
    type: str_var
  - id: reserved3
    size: 8
  - id: var_sys
    type: sys_var
    repeat: expr
    repeat-expr: 256
  - id: reserved4
    size: 4 * 228

types:
  text_attrs:
    seq:
      - id: msg_size
        type: u1
      - id: msg_color
        type: u1
      - id: back_color
        type: u1
      - id: frame_color
        type: u1
  rectangle_w:
    seq:
      - id: x
        type: u2
      - id: y
        type: u2
      - id: width
        type: u2
      - id: height
        type: u2
  stack:
    seq:
      - id: location
        type: u4
    instances:
      data:
        pos: location
        type: stack_data
  stack_data:
    seq:
      - id: size
        type: u4
      - id: reserved
        size: 12
      - id: data
        size: size
  str_var:
    seq:
      - id: location
        type: u4
    instances:
      data:
        pos: location
        type: str_var_data
  str_var_data:
    seq:
      - id: size
        type: u4
      - id: count
        type: u4
      - id: maxlen
        type: u4
      - id: reserved
        size: 4
      - id: values
        type: strz
        repeat: expr
        repeat-expr: count
  sys_var:
    seq:
      - id: location
        type: u4
    instances:
      data:
        pos: location
        type: sys_var_data
        if: location != 0
    -webide-representation: '{location}'
  sys_var_data:
    seq:
      - id: size
        type: u4
      - id: page_no
        type: u4
      - id: reserved
        size: 8
      - id: values
        type: u2
        repeat: expr
        repeat-expr: size / 2
