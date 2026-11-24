meta:
  id: mpls
  title: MPLS packet
  xref:
    rfc: 3032
  license: LicenseRef-All-Rights-Reserved
  imports:
    - ipv4_packet
    - ipv6_packet
doc: |
  Multiprotocol Label Switching (MPLS) forwards packets by short labels
  instead of network addresses. A labeled packet starts with a stack of
  one or more labels, followed by the original packet.

  Nothing in the label stack tells what the payload is. Like most tools,
  this spec looks at its first 4 bits, which hold the version number of an
  IPv4 or IPv6 packet.
doc-ref: https://www.rfc-editor.org/rfc/rfc3032#section-2.1
seq:
  - id: label_stack
    type: label_stack_entry
    repeat: until
    repeat-until: _.is_bottom_of_stack
  - id: body
    size-eos: true
    type:
      switch-on: ip_version
      cases:
        4: ipv4_packet
        6: ipv6_packet
instances:
  first_body_byte:
    pos: label_stack.size * 4
    type: u1
    if: not _io.eof
  ip_version:
    value: first_body_byte >> 4
    if: not _io.eof
types:
  label_stack_entry:
    seq:
      - id: label
        type: b20
      - id: traffic_class
        type: b3
        doc: Formerly known as the experimental (EXP) or class of service bits.
      - id: is_bottom_of_stack
        type: b1
      - id: ttl
        type: u1
        doc: Time to live.
