meta:
  id: fr_frame
  title: Frame Relay frame
  xref:
    rfc: 2427
  license: LicenseRef-All-Rights-Reserved
  imports:
    - ipv4_packet
    - ipv6_packet
    - arp_packet
  endian: be
doc: |
  Frame Relay is a wide area network technology that switches frames along
  virtual circuits, each identified by a data link connection identifier
  (DLCI).

  This spec describes a frame with the usual 2-byte address field, without
  flags and frame check sequence. The payload follows in one of two
  encapsulations: the standard one, which starts with a control byte of
  0x03 and a network layer protocol ID (NLPID), or the one introduced by
  Cisco, which starts with an EtherType.
doc-ref:
  - https://www.rfc-editor.org/rfc/rfc2427
  - https://gitlab.com/wireshark/wireshark/-/blob/master/epan/dissectors/packet-fr.c
seq:
  - id: dlci_high
    type: b6
  - id: is_response
    type: b1
    doc: Command/response (C/R) bit.
  - id: has_short_address
    type: b1
    doc: Address extension (EA) bit of the first byte, always 0.
  - id: dlci_low
    type: b4
  - id: has_forward_congestion
    type: b1
    doc: Forward explicit congestion notification (FECN).
  - id: has_backward_congestion
    type: b1
    doc: Backward explicit congestion notification (BECN).
  - id: is_discard_eligible
    type: b1
    doc: Discard eligibility (DE).
  - id: is_last_address_byte
    type: b1
    doc: Address extension (EA) bit of the second byte, always 1.
  - id: payload
    size-eos: true
    type:
      switch-on: control
      cases:
        0x03: nlpid_payload
        _: cisco_payload
instances:
  dlci:
    value: (dlci_high << 4) | dlci_low
  control:
    pos: 2
    type: u1
types:
  nlpid_payload:
    seq:
      - id: control
        type: u1
        doc: 0x03, unnumbered information.
      - id: padding
        size: 1
        if: first_byte == 0
        doc: Optional zero byte that aligns the payload.
      - id: nlpid
        type: u1
        enum: nlpid
      - id: body
        size-eos: true
        type:
          switch-on: nlpid
          cases:
            'nlpid::snap': snap_packet
            'nlpid::ipv4': ipv4_packet
            'nlpid::ipv6': ipv6_packet
    instances:
      first_byte:
        pos: 1
        type: u1
  snap_packet:
    seq:
      - id: organization_code
        size: 3
      - id: protocol_id
        type: u2
        enum: ether_type_enum
        doc: An EtherType if `organization_code` is 0.
      - id: body
        size-eos: true
        type:
          switch-on: protocol_id
          cases:
            'ether_type_enum::ipv4': ipv4_packet
            'ether_type_enum::arp': arp_packet
            'ether_type_enum::ipv6': ipv6_packet
  cisco_payload:
    seq:
      - id: ether_type
        type: u2
        enum: ether_type_enum
      - id: body
        size-eos: true
        type:
          switch-on: ether_type
          cases:
            'ether_type_enum::ipv4': ipv4_packet
            'ether_type_enum::arp': arp_packet
            'ether_type_enum::ipv6': ipv6_packet
enums:
  nlpid:
    0x08: q933
    0x80: snap
    0x8e: ipv6
    0xcc: ipv4
  ether_type_enum:
    0x0800: ipv4
    0x0806: arp
    0x86dd: ipv6
