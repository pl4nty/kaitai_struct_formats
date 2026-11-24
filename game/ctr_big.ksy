# Imported from https://github.com/CTR-tools/CTR-tools/blob/8edc826ccab49099776f6431e25b4136a2ecbec3/formats/ctr_big.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ctr_big
  title: Crash Team Racing (PS1) BIG container
  application: Crash Team Racing
  file-extension: big
  license: GPL-2.0-only
  endian: le

doc-ref: https://github.com/CTR-tools/CTR-tools/blob/master/formats/ctr_big.ksy

seq:
  - id: magic
    contents: [0, 0, 0, 0]
  - id: num_entries
    type: u4
  - id: entries
    type: big_entry
    repeat: expr
    repeat-expr: num_entries

types:
  big_entry:
    seq:
      - id: offset
        type: u4
      - id: size
        type: u4
    instances:
      data:
        pos: offset * 2048
        size: size
