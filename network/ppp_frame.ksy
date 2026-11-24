meta:
  id: ppp_frame
  title: Point-to-Point Protocol (PPP) frame in HDLC-like framing
  xref:
    rfc:
      - 1661
      - 1662
  license: LicenseRef-All-Rights-Reserved
  imports:
    - ipv4_packet
    - ipv6_packet
    - mpls
    - lcp_packet
    - ipcp_packet
    - ccp_packet
  endian: be
doc: |
  PPP carries the packets of several network protocols over a link between
  two peers, e.g. a serial line or a dial-up connection.

  This spec describes a frame in HDLC-like framing without the flag bytes,
  byte stuffing and frame check sequence, the way it is stored in a capture
  file. It expects the address and control bytes and a 2-byte protocol
  number, i.e. no compression of these fields.
doc-ref:
  - https://www.rfc-editor.org/rfc/rfc1662#section-3
  - https://www.iana.org/assignments/ppp-numbers/ppp-numbers.xhtml
seq:
  - id: address
    contents: [0xff]
  - id: control
    contents: [0x03]
  - id: protocol
    type: u2
    enum: protocol_enum
  - id: body
    size-eos: true
    type:
      switch-on: protocol
      cases:
        'protocol_enum::ipv4': ipv4_packet
        'protocol_enum::ipv6': ipv6_packet
        'protocol_enum::mpls_unicast': mpls
        'protocol_enum::lcp': lcp_packet
        'protocol_enum::ipcp': ipcp_packet
        'protocol_enum::ccp': ccp_packet
enums:
  protocol_enum:
    0x0021: ipv4
    0x0057: ipv6
    0x0281: mpls_unicast
    0x8021: ipcp
    0x8057: ipv6cp
    0x80fd: ccp
    0xc021: lcp
    0xc023: pap
    0xc223: chap
