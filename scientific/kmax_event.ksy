# Imported from https://github.com/exaos/cau4np/blob/1cc6541d9a7656ed80f5de4816f7ee8ba31896f4/doc/kmax_event.ksy
# -*- mode: yaml; coding: utf-8; -*-
meta:
  id: kmax_event
  title: Kmax Event Output
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: header
    size: 512
    type: kmax_header
  - id: event_block
    type: kmax_event_block
    repeat: until
    repeat-until: _.is_footer
  - id: event_footer
    contents: [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
types:
  kmax_header:
    seq:
      - id: magic
        contents: [ 0x02, 0x00, 0x00, 0x01 ]
  kmax_event_block:
    seq:
      - id: event_par
        type: u4
      - id: blk_count
        type: u4
      - id: event_entry
        type: kmax_event_entry
        repeat: expr
        repeat-expr: blk_count
    instances:
      is_footer:
        value: event_par == 0xFFFF_FFFF and blk_count == 0xFFFF_FFFF
      event_size:
        value: (event_par & 0xFFFF)
      event_type:
        value: (event_par & 0xFFFF_0000) >> 16
    types:
      kmax_event_entry:
        seq:
          - id: par
            type: u4
            repeat: expr
            repeat-expr: _parent.event_size
