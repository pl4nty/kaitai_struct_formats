# Imported from https://gitlab.cern.ch/sianders/hgcaldaqkaitai/-/raw/master/src/emp.ksy
meta:
  id: hgcal_emp
  title: CMS HGCAL EMP capture
  license: LicenseRef-All-Rights-Reserved
  imports:
    - hgcal_minidaq
    - /network/pcap
  bit-endian: le
  
seq:
  - id: pkt_id
    type: b36
  - id: run_id
    type: b12
  - id: pkt_len
    type: u1
  - id: pkt_type
    type: u1
    enum: pkt_type
  - id: body
    size: pkt_len * 8
    type: hgcal_minidaq

      

enums:
  pkt_type:
    0xaa: single
    0xac: aggregate
