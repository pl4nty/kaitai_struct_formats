# Imported from https://github.com/atylo/automation-scripts/blob/2a762a1c6375655318c0935258e0a430bb4c5798/ProjectEGG/Kaitai%20Struct%20schemes/t88%20Tape%20image.ksy
meta:
  id: t88
  title: T88 cassette tape image (PC-8801)
  file-extension: t88
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII
  endian: le

seq:
  - id: header
    size: 24
    type: str
    encoding: ASCII
  - id: version
    size: 6
  - id: tags
    type: tag
    repeat: until
    repeat-until: _.is_end

types:
  tag:
    seq:
      - id: id
        type: u2
      - id : pad2
        type: u2
      - id: areastarttime
        type: u2
        if: id != 0
      - id: reserved
        size: 2
        if: id != 0
      - id: area_length
        type: u2
        if: id != 0
      - id: pad3
        type: u2      
        if: id != 0
      - id: length
        type: u2
        if: id == 257
      - id: baud
        type: u2
        if: id == 257
      - id: data
        size: length
        if: id == 257

    instances:
      is_end:
        value: id == 0
