# Imported from https://github.com/Evidlo/dotrm/blob/f8a43480eea7362f544fa5e2e8e01ac6c606ad93/test.ksy
meta:
  id: remarkable_rm_v5
  file-extension: rm
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: header
  - id: num_layers
    type: s4
  - id: layers
    type: layer
    repeat: expr
    repeat-expr: num_layers
enums:
  color:
    0: black
    1: gray
    2: white
  brush:
    6: eraser
    8: eraserselect
    12: paintbrush
    13: mechanical
    14: pencil
    15: ballpoint
    16: marker
    17: fineliner
    18: highlighter
types:
  header:
    seq:
      - id: magic
        contents: 'reMarkable .lines file, version='
      - id: version
        size: 1
        type: str
        encoding: ASCII
      - id: spaces
        size: 10
  point:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: speed
        type: f4
      - id: direction
        type: f4
      - id: width
        type: f4
      - id: pressure
        type: f4
  line:
    seq:
      - id: brush_type
        type: s4
        enum: brush
      - id: color
        type: s4
        enum: color
      - id: padding
        size: 4
      - id: brush_size
        type: f4
      - id: unknown
        type: s4
      - id: num_points
        type: s4
      - id: points
        type: point
        repeat: expr
        repeat-expr: num_points
  layer:
    seq:
      - id: num_lines
        type: s4
      - id: lines
        type: line
        repeat: expr
        repeat-expr: num_lines
