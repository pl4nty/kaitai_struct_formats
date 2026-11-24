meta:
  id: mpls
  title: MPLS label switch packet
  license: LicenseRef-All-Rights-Reserved
  imports:
    - ipv4_packet
seq:
  - id: header
    type: mpls_header
    repeat: until
    repeat-until: _.bottom_of_stack
  - id: body
    size-eos: true
    type: ipv4_packet
types:
  mpls_header:
    seq:
      - id: label
        type: b20
      - id: cos
        type: b3
      - id: bottom_of_stack
        type: b1
      - id: ttl
        type: b8
