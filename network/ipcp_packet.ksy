meta:
  id: ipcp_packet
  title: PPP Internet Protocol Control Protocol (IPCP) packet
  xref:
    rfc:
      - 1332
      - 1877
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  The IP Control Protocol configures the use of IPv4 over a PPP link, most
  notably the IP addresses of both ends. Its packets have the same layout
  as the ones of LCP and are carried in PPP frames with protocol number
  0x8021.
doc-ref: https://www.rfc-editor.org/rfc/rfc1332#section-3
seq:
  - id: code
    type: u1
    enum: code_enum
  - id: identifier
    type: u1
    doc: Matches replies to requests.
  - id: length
    type: u2
    doc: |
      Length of the packet in bytes, including `code`, `identifier` and
      this field. Anything that follows the packet is padding.
  - id: data
    size: length - 4
    type:
      switch-on: code
      cases:
        'code_enum::configure_request': options_type
        'code_enum::configure_ack': options_type
        'code_enum::configure_nak': options_type
        'code_enum::configure_reject': options_type
types:
  options_type:
    seq:
      - id: options
        type: option
        repeat: eos
  option:
    seq:
      - id: type
        type: u1
        enum: type_enum
      - id: length
        type: u1
        doc: Length of the option in bytes, including `type` and this field.
      - id: value
        size: length - 2
enums:
  code_enum:
    1: configure_request
    2: configure_ack
    3: configure_nak
    4: configure_reject
    5: terminate_request
    6: terminate_ack
    7: code_reject
  type_enum:
    1:
      id: ip_addresses
      doc: Deprecated.
    2: ip_compression_protocol
    3: ip_address
    4: mobile_ipv4
    129: primary_dns_server_address
    130: primary_nbns_server_address
    131: secondary_dns_server_address
    132: secondary_nbns_server_address
