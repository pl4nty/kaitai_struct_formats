meta:
  id: arp_packet
  title: Address Resolution Protocol (ARP) packet
  xref:
    rfc: 826
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  ARP finds the hardware address (e.g. the Ethernet MAC address) that
  belongs to a protocol address (e.g. an IPv4 address) on the local
  network. The reverse (RARP) and inverse (InARP) variants use the same
  packet layout.
doc-ref: https://www.rfc-editor.org/rfc/rfc826
seq:
  - id: hardware_type
    type: u2
    enum: hardware_type
  - id: protocol_type
    type: u2
    doc: EtherType of the protocol, e.g. 0x0800 for IPv4.
  - id: len_hardware_address
    type: u1
  - id: len_protocol_address
    type: u1
  - id: opcode
    type: u2
    enum: opcode_enum
  - id: sender_hardware_address
    size: len_hardware_address
  - id: sender_protocol_address
    size: len_protocol_address
  - id: target_hardware_address
    size: len_hardware_address
  - id: target_protocol_address
    size: len_protocol_address
enums:
  hardware_type:
    1: ethernet
    15: frame_relay
  opcode_enum:
    1: request
    2: reply
    3: reverse_request
    4: reverse_reply
    8: inverse_request
    9: inverse_reply
