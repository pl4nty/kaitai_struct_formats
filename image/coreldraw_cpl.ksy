# Imported from https://github.com/kaitai-io/coreldraw_cdr.ksy/blob/9d8e2704b946961f5114115f1a488750a3c86ed0/coreldraw_cpl.ksy
meta:
  id: coreldraw_cpl
  title: CorelDRAW legacy color palette
  application: CorelDRAW X4 and older
  file-extension: cpl
  license: MIT
  imports:
    - coreldraw_cdr
  endian: le
doc: |
  CorelDRAW calls this format "Legacy custom palette (*.cpl)" now (since
  CorelDRAW X5, palettes are stored in .xml files instead)
doc-ref: https://github.com/sk1project/uniconvertor/blob/973d5b6f/src/uc2/formats/cpl/cpl_model.py#L64-L121
seq:
  - id: magic
    contents: [0xcc, 0xdc]
    doc-ref: https://github.com/sk1project/uniconvertor/blob/973d5b6f/src/uc2/formats/cpl/cpl_const.py#L24
  - id: num_colors
    type: u2
  - id: colors
    type: color
    repeat: expr
    repeat-expr: num_colors
types:
  color:
    seq:
      - id: value
        type: coreldraw_cdr::color::color_new
      - id: len_name
        type: u1
      - id: name
        size: len_name
        type: str
        encoding: windows-1252
