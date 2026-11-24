meta:
  id: lcp_packet
  title: PPP Link Control Protocol (LCP) packet
  xref:
    rfc:
      - 1661
      - 1570
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  The Link Control Protocol establishes, configures and tests a PPP link.
  Its packets are carried in PPP frames with protocol number 0xc021.
doc-ref: https://www.rfc-editor.org/rfc/rfc1661#section-5
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
    8: protocol_reject
    9: echo_request
    10: echo_reply
    11: discard_request
    12: identification
    13: time_remaining
  type_enum:
    0: vendor_specific
    1: maximum_receive_unit
    2: async_control_character_map
    3: authentication_protocol
    4: quality_protocol
    5: magic_number
    7: protocol_field_compression
    8: address_and_control_field_compression
    9: fcs_alternatives
    10: self_describing_pad
    11: numbered_mode
    13: callback
    17: multilink_mrru
    18: multilink_short_sequence_number_header
    19: multilink_endpoint_discriminator
