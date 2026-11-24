# Imported from https://github.com/exaos/cau4np/blob/1cc6541d9a7656ed80f5de4816f7ee8ba31896f4/doc/ortec_roi.ksy
# - mode: yaml; coding: utf-8; -*-
meta:
  id: ortec_roi
  title: ORTEC ROI File
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    size: 128
    type: ortec_roi_header
  - id: roi_block_start
    type: s2
    repeat: expr
    repeat-expr: 64
  - id: roi_block_num
    type: s2
    repeat: expr
    repeat-expr: 64
types:
  ortec_roi_header:
    seq:
      - id: magic
        contents: [ 0x01, 0x00, 0x00, 0x08 ]
    instances:
      number_of_records:
        pos: 42
        type: s2
      max_record_used:
        pos: 56
        type: s2
      max_record_in_use:
        pos: 58
        type: s2
