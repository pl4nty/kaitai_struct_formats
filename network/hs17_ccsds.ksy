# Imported from https://gist.githubusercontent.com/lokkju/2a83ba63af47ac348639b94a2e6e508d/raw/8527f6de5fa25e8e8dba72bd8a7bf93bff881b5b/hs17.ksy
meta:
  id: hs17_ccsds
  file-extension: hs17
  license: LicenseRef-All-Rights-Reserved
  endian: be
  
seq:
  - id: packet
    type: ccsds_packet
    repeat: expr
    repeat-expr: 6

types:
  ccsds_packet:
    seq:
      - id: header
        type: ccsds_header
      - id: payload
        size: header.ccsds_plength + 1
        type:
          switch-on: header.ccsds_apid
          cases:
            102: payload_flag
            103: payload_eps
            105: payload_blob
  payload_blob:
    seq:
      - id: blob
        size: 12
  payload_eps:
    seq:
      - id: blob
        size-eos: true
  payload_flag:
    seq:
      - id: flag
        type: b7
        repeat: eos
  ccsds_header:
    seq:
      - id: ccsds_version
        type: b3
      - id: ccsds_type
        type: b1
      - id: ccsds_sec_hd
        type: b1
      - id: ccsds_apid
        type: b11
      - id: ccsds_gp_flags
        type: b2
      - id: ccsds_ssc
        type: b14
      - id: ccsds_plength
        type: u2
  
