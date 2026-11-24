# Imported from https://github.com/stellargames/bakagain/blob/513a79864ff79fe27f917e721e8cbec714e68af3/formats/palette.ksy
# Licence and copyright: see _community/README.md
meta:
  id: bak_palette
  file-extension: pal
  license: MIT
  endian: le
doc: |
  Color palette. Not entirely correct since this only takes VGA palettes into
  account.
seq:
  - id: main_tag
    contents: 'PAL:'
  - id: file_size
    type: u2
  - id: unknown1
    type: u2
  - id: vga_tag
    contents: 'VGA:'
  - id: chunk_size
    type: u4
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
