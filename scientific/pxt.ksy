# Imported from https://github.com/htmdec/htmdec_formats/blob/8bd79be26ff363caf85d62131224c9403561c864/src/htmdec_formats/ksy_files/pxtfile.ksy
# Licence and copyright: see _community/README.md
meta:
  id: pxt
  file-extension: pxtfile
  license: MIT
  endian: le
seq:
  - id: unk1
    type: u2
  - id: unk2
    type: u2
  - id: unk3
    type: u4
  - id: unk4
    type: u2
  - id: unk5
    type: u2
  - id: wave_size
    type: u4
  - id: wave
    size: wave_size + 40
    type: wave_data
  - id: unk7
    type: u4
    repeat: expr
    repeat-expr: 4
  - id: metadata
    size-eos: true
    type: str
    encoding: UTF-8
types:
  wave_data:
    seq:
      - id: unk0
        type: u4
        repeat: expr
        repeat-expr: 21
      - id: name
        size: 40
        type: str
        encoding: UTF-8
      - id: num_rows
        type: u4
      - id: num_cols
        type: u4
      - id: num_layers
        type: u4
      - id: unk1
        type: u4
      - id: row_delta
        type: f8
      - id: col_delta
        type: f8
      - id: layer_delta
        type: f8
      - id: unk2
        type: f8
      - id: row_start
        type: f8
      - id: col_start
        type: f8
      - id: layer_start
        type: f8
      - id: unk4
        type: f8
      - id: unk5
        type: f4
        repeat: expr
        repeat-expr: 39
      - id: layers
        type: layer
        repeat: expr
        repeat-expr: "num_layers > 0 ? num_layers : 1"
  layer:
    seq:
      - id: value
        type: f4
        repeat: expr
        repeat-expr: "(_parent.num_rows > 0 ? _parent.num_rows : 1) * (_parent.num_cols > 0 ? _parent.num_cols : 1)"
