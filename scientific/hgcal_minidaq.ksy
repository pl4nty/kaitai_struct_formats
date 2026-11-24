# Imported from https://gitlab.cern.ch/sianders/hgcaldaqkaitai/-/raw/master/src/minidaq.ksy
meta:
  id: hgcal_minidaq
  title: CMS HGCAL miniDAQ event
  license: LicenseRef-All-Rights-Reserved
  imports:
    - hgcal_econd
  bit-endian: le

  
seq:
  - id: header
    type: header

types:
  header:
    seq:
      - id: econd_status
        # enum: econd_status
        type: b3
        repeat: expr
        repeat-expr: 12
      - id: orbit_id
        type: b3
      - id: event_id
        type: b6
      - id: bx_id
        type: b12
      - id: reserved
        type: b7
      - id: fake_header
        size: 8
      - id: body
        type: hgcal_econd
      

      

# enums:
#   econd_status:
#     0: normal
#     1: reserved
#     2: payload_crc
#     3: event_id_mismatch
#     4: timeout
#     5: bcid_or_orbit_is_mismatch
#     6: main_buffer_overflow
#     7: unconnected
