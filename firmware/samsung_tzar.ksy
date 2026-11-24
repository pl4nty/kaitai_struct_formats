# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/samsung_tzar/samsung_tzar.ksy
# Licence and copyright: see _community/README.md
meta:
  id: samsung_tzar
  title: Samsung Tzar
  license: CC0-1.0
  encoding: UTF-8
  endian: le
doc-ref: https://gist.github.com/astarasikov/f47cb7f46b5193872f376fa0ea842e4b
seq:
  - id: header
    type: header
  - id: entries
    size: header.tzar_len - header._sizeof
    type: entries
types:
  header:
    seq:
      - id: magic
        contents: [0x7f, 0xa5, 0x54, 0x41]
        # is this correct???
      - id: tzar_count
        type: u4
      - id: tzar_len
        type: u4
      - id: num_files
        type: u4
  entries:
    seq:
      - id: entries
        type: entry
        repeat: expr
        repeat-expr: _root.header.num_files
  entry:
    seq:
      - id: len_filename
        type: u4
      - id: len_data
        type: u4
      - id: filename
        size: len_filename
        type: strz
      - id: data
        size: len_data
