# Imported from https://github.com/infval/AMLUnpacker_TrueRemembrance/blob/0c06fd5887cb70a24b5878ea392d2654fac0ee23/AML_Arciver.ksy
meta:
  id: true_remembrance_aml
  file-extension: arc
  license: Unlicense
  encoding: ASCII
  endian: le
seq:
  - id: hdr
    type: header
  - id: files
    type: file
    repeat: expr
    repeat-expr: hdr.file_count
types:
  header:
    seq:
      - id: magic
        contents: 'AML_Arciver'
      - id: padding
        size: 128 - 11
      - id: file_count
        type: u4
  file:
    seq:
      - id: path
        size: 64
        type: strz
      - id: size
        type: u4
      - id: data
        size: size
