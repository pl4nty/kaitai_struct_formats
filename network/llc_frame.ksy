meta:
  id: llc_frame
  title: IEEE 802.2 Logical Link Control (LLC) frame
  license: LicenseRef-All-Rights-Reserved
  imports:
    - ipv4_packet
    - ipv6_packet
    - arp_packet
    - mpls
  endian: be
doc: |
  LLC is the upper half of the data link layer of IEEE 802 networks. Its
  header names the protocols of the sender and of the receiver by service
  access points (SAPs).

  The SAP 0xaa stands for the Subnetwork Access Protocol (SNAP) extension:
  a second header that identifies the payload by an organization code and
  a protocol number, which is an EtherType if the organization is 0.
doc-ref: https://www.rfc-editor.org/rfc/rfc1042
seq:
  - id: dsap
    type: u1
    doc: Destination service access point.
  - id: ssap
    type: u1
    doc: Source service access point.
  - id: control
    type: control_field
  - id: snap
    size-eos: true
    type: snap_packet
    if: dsap == 0xaa and ssap == 0xaa
  - id: body
    size-eos: true
    if: not (dsap == 0xaa and ssap == 0xaa)
types:
  control_field:
    seq:
      - id: command
        type: b6
      - id: frame_type
        type: b2
        doc: |
          3 for an unnumbered frame, whose control field is one byte long.
          Other values belong to information and supervisory frames, which
          have a second control byte.
      - id: additional
        type: u1
        if: frame_type != 3
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
            'ether_type_enum::mpls': mpls
enums:
  ether_type_enum:
    0x0800: ipv4
    0x0806: arp
    0x86dd: ipv6
    0x8847: mpls
