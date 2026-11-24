# Imported from https://gitlab.cern.ch/sianders/hgcaldaqkaitai/-/raw/master/src/econd.ksy
meta:
  id: hgcal_econd
  title: CMS HGCAL ECON-D data packet
  license: LicenseRef-All-Rights-Reserved
  endian: le
  bit-endian: le

seq:
  - id: header
    type: header

types:
  header:
    seq:
      - id: crc
        type: b8
      - id: reset_request
        type: b2
      - id: stat_or
        type: b1
      - id: orbit_number
        type: b3
      - id: l1a_number
        type: b6
      - id: bx_number
        type: b12
      - id: hamming
        type: b6
      - id: truncated
        type: b1      
      - id: match
        type: b1
      - id: event_bx_orbit_reconstruction
        type: b2
      - id: header_trailer_reconstruction
        type: b2
      - id: expected
        type: b1
      - id: pass_through
        type: b1
      - id: payload_length
        type: b9
      - id: header_marker
        type: b9      
        valid:
          expr: header_marker == 0xac
      
      
      
      
      
      
      
      
      
      
      
      
      
      
