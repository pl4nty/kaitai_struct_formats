# Imported from https://github.com/OK-DMR/dmr-kaitai/blob/7489ff1a8b418e3d37e2a0268acbaf2710543d93/okdmr/kaitai/hytera/radio_registration_service.ksy
meta:
  id: radio_registration_service
  title: Hytera DMR radio registration service
  license: AGPL-3.0-only
  imports:
    - radio_ip
seq:
  - id: opcode
    contents: [0x00]
  - id: rrs_type
    type: u1
    enum: rrs_types
  - id: message_length
    type: u2be
    doc: length of the message from next field to the end of RRS message
  - id: radio_ip
    type: radio_ip
  - id: result
    type: u1
    if: rrs_type == rrs_types::registration_ack or rrs_type == rrs_types::online_check_ack
  - id: valid_time
    type: u4be
    if: rrs_type == rrs_types::registration_ack
    doc: |
      number of seconds the online registration message shall be resended from
      terminal
enums:
  rrs_types:
    0x03: registration
    0x80: registration_ack
    0x01: de_registration
    0x02: online_check
    0x82: online_check_ack
