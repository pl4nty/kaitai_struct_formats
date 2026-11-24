# Imported from https://github.com/robin-francois/aud-dts-kaitai-struct/blob/86b24e5642afe575da8b6eb14d3537cf1952017e/aud_dts.ksy
meta:
  id: aud_dts
  file-extension: aud
  license: GPL-3.0-only
  endian: le
seq:
  - id: header
    type: header
types:
  bcd1:
    seq:
      - id: b1
        type: u1
    instances:
      digit1:
        value: b1 & 0xf
      digit2:
        value: (b1 & 0xf0) >> 4
      as_int:
        value: >
          digit1 +
          digit2 * 10 
  header:
    seq:
      - id: title
        size: 60
        type: str
        encoding: ASCII
      - id: language
        size: 8
        type: str
        encoding: ASCII
      - id: studio
        size: 6
        type: str
        encoding: ASCII
      - id: unknown
        type: u4
      - id: reel_number
        type: u2
      - id: serial
        type: u2
      - id: channels
        type: u2
      - id: dts_start_frame
        type: bcd1
      - id: dts_start_sec
        type: bcd1
      - id: dts_start_min
        type: bcd1
      - id: dts_start_hour
        type: bcd1
      - id: duration_frame
        type: bcd1
      - id: duration_sec
        type: bcd1
      - id: duration_min
        type: bcd1
      - id: duration_hour
        type: bcd1
