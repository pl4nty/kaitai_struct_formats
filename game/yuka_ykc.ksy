# Imported from https://github.com/AtomCrafty/yukatool/blob/db06e24fa29045c897676199de6dfb217b1c65cc/doc/ykc_format.ksy
# Licence and copyright: see _community/README.md
meta:
  id: yuka_ykc
  file-extension: ykc
  license: GPL-3.0-only
  endian: le
  
seq:
  - id: magic
    contents: ['YKC001', 0, 0]
  - id: header_length
    type: u4
  - type: u4
  - id: index
    type: ykc_index
    
types:
  ykc_index:
    seq:
      - id: offset
        type: u4
      - id: length
        type: u4
    instances:
      count:
        value: length / 20
      files:
        pos: offset
        type: ykc_file_entry
        repeat: expr
        repeat-expr: count
  ykc_file_entry:
    seq:
      - id: name_offset
        type: u4
      - id: name_length
        type: u4
      - id: data_offset
        type: u4
      - id: data_length
        type: u4
      - type: u4
    instances:
      name:
        pos: name_offset
        size: name_length
        type: str
        encoding: ASCII
      data:
        pos: data_offset
        size: data_length
        process: xor(0xaa)
