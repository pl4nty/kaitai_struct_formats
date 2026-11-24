# Imported from https://github.com/hbkworld/Open-Interface-for-Sound-Level-Meter/blob/4f0d4f8b38d4871cc8ba0871d386f0611bbbd8bc/Python%20examples/webxi/webxi-header.ksy
meta:
  id: webxi_header
  title: WebXi stream header
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents: [0x42, 0x4b]
  - id: header_length
    type: u2
  - id: message_type
    type: u2
    enum: e_message_type
  - id: content_version
    type: u2
  - id: reserved2
    type: u4
  - id: time
    type: u8
  - id: content_length
    type: u4

enums:
  e_message_type:
    1: e_sequence_data
    2: e_data_quality
    3: state
    4: status
    5: trigger
    6: node
    7: sync
    9: debug
    10: package
    11: aux_sequence_data
