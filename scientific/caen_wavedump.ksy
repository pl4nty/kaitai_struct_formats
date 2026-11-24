# Imported from https://github.com/exaos/cau4np/blob/1cc6541d9a7656ed80f5de4816f7ee8ba31896f4/doc/caen_wavedump.ksy
# -*- mode: yaml; coding: utf-8; -*-
meta:
  id: caen_wavedump
  title: CAEN WaveDump output
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    size: 24
    type: caen_wavedump_header
  - id: wave
    type: u2
    repeat: expr
    repeat-expr: (header.rec_length-24) / 2
types:
  caen_wavedump_header:
    seq:
      - id: rec_length
        type: u4
      - id: board_id
        type: u4
      - id: pattern
        type: u4
      - id: channel
        type: u4
      - id: event_counter
        type: u4
      - id: trig_time_tag
        type: u4
