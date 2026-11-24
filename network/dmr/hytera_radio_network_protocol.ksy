# Imported from https://github.com/OK-DMR/dmr-kaitai/blob/7489ff1a8b418e3d37e2a0268acbaf2710543d93/okdmr/kaitai/hytera/hytera_radio_network_protocol.ksy
meta:
  id: hytera_radio_network_protocol
  title: Hytera Radio Network Protocol (HRNP)
  license: AGPL-3.0-only
  imports:
    - hytera_dmr_application_protocol
seq:
  - id: header_identifier
    contents: [0x7E]
  - id: version
    type: u1
  - id: block
    type: u1
  - id: opcode
    type: u1
    enum: opcodes
  - id: source_id
    type: u1
  - id: destination_id
    type: u1
  - id: packet_number
    type: u2be
  - id: hrnp_packet_length
    type: u2be
  - id: checksum
    type: u2be
  - id: data
    type: hytera_dmr_application_protocol
    if: opcode == opcodes::data
enums:
  opcodes:
    0xFE: connect
    0xFD: accept
    0xFC: reject
    0xFB: close
    0xFA: close_ack
    0x00: data
    0x10: data_ack
