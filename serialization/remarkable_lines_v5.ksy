# Imported from https://github.com/matomatical/reMarkable-kaitai/blob/730ba62be37a40ad290b568844150687e9c6c094/rm_v5.ksy
# Licence and copyright: see _community/README.md
meta:
  id: remarkable_lines_v5
  title: reMarkable .lines file, version=5
  file-extension: rm
  license: MIT
  endian: le
seq:
  - id: header
    size: 33
    type: str
    encoding: ASCII
  - id: header_padding
    size: 10
    type: str
    encoding: ASCII
  # before version 3, num_pages (s4) bytes here
  - id: pages
    type: rm_page
    repeat: expr
    repeat-expr: 1
types:
  rm_page:
    seq:
      - id: num_layers
        type: s4
      - id: layers
        type: rm_layer
        repeat: expr
        repeat-expr: num_layers
  rm_layer:
    seq: 
      - id: num_lines
        type: s4
      - id: lines
        type: rm_line
        repeat: expr
        repeat-expr: num_lines
  rm_line:
    seq:
      - id: brush_type
        type: s4
      - id: color
        type: s4
      - id: unknown_line_attribute
        type: s4
        doc: suspected to be 'selected' flag
      - id: brush_base_size
        type: f4
        doc: width
      # only in version 5:
      - id: unknown_line_attribute_2
        type: s4
      - id: num_points
        type: s4
      - id: points
        type: rm_point
        repeat: expr
        repeat-expr: num_points
  rm_point:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: speed
        type: f4
      - id: direction
        type: f4
      - id: width
        type: f4
      - id: pressure
        type: f4
