# Imported from https://github.com/1j01/anypalette.js/blob/eaf17cca78203bf2e68298137859f3f23cc46520/src/formats/ksy/act.ksy
meta:
  id: adobe_color_table
  application: Adobe Photoshop
  file-extension: act
  xref:
    wikidata: Q28551294
  tags:
    - color
    - palette
  license: CC0-1.0
doc: Adobe Color Table is a very simple format for RGB color palettes.
seq:
  - id: colors
    type: color
    repeat: expr
    repeat-expr: 256
types:
  color:
    seq:
      - id: red
        type: u1
      - id: green
        type: u1
      - id: blue
        type: u1
