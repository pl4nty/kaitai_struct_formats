# Imported from https://github.com/mnakamura1337/engine_bgi/blob/7b1995a54ecafbb6c01d941a6f59c759e1bc81fd/containers/bgi_bwef.ksy
meta:
  id: bgi_bwef
  application: BGI (Buriko General Interpreter)
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    size: 0x120
    type: header
  - id: steps
    type: u4
    repeat: expr
    repeat-expr: header.num_steps
  - id: rest
    size-eos: true
types:
  header:
    seq:
      - id: magic
        contents: 'bwef    '
      - id: smth1
        type: u4
      - id: smth2
        type: u4
      - id: always_288
        type: u4
      - id: num_steps
        type: u4
      - id: always_40
        type: u4
      - id: file_name
        type: strz
        encoding: Shift_JIS
