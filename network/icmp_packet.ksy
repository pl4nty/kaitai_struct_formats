meta:
  id: icmp_packet
  title: ICMP network packet
  xref:
    rfc: 792
    wikidata: Q13162
  license: CC0-1.0
  endian: be
seq:
  - id: icmp_type
    type: u1
    enum: icmp_type_enum
  - id: destination_unreachable
    type: destination_unreachable_msg
    if: icmp_type == icmp_type_enum::destination_unreachable
  - id: time_exceeded
    type: time_exceeded_msg
    if: icmp_type == icmp_type_enum::time_exceeded
  - id: echo
    type: echo_msg
    if: icmp_type == icmp_type_enum::echo or icmp_type == icmp_type_enum::echo_reply
  - id: redirect
    type: redirect_msg
    if: icmp_type == icmp_type_enum::redirect
  - id: parameter_problem
    type: parameter_problem_msg
    if: icmp_type == icmp_type_enum::parameter_problem
  - id: timestamp
    type: timestamp_msg
    if: icmp_type == icmp_type_enum::timestamp or icmp_type == icmp_type_enum::timestamp_reply
enums:
  icmp_type_enum:
    0: echo_reply
    3: destination_unreachable
    4: source_quench
    5: redirect
    8: echo
    9:
      id: router_advertisement
      doc-ref: https://www.rfc-editor.org/rfc/rfc1256
    10:
      id: router_solicitation
      doc-ref: https://www.rfc-editor.org/rfc/rfc1256
    11: time_exceeded
    12: parameter_problem
    13: timestamp
    14: timestamp_reply
    15:
      id: information_request
      doc: Deprecated by RFC 6918
    16:
      id: information_reply
      doc: Deprecated by RFC 6918
    17:
      id: address_mask_request
      doc: Defined in RFC 950, deprecated by RFC 6918
    18:
      id: address_mask_reply
      doc: Defined in RFC 950, deprecated by RFC 6918
types:
  destination_unreachable_msg:
    seq:
      - id: code
        type: u1
        enum: destination_unreachable_code
      - id: checksum
        type: u2
    enums:
      destination_unreachable_code:
        0: net_unreachable
        1: host_unreachable
        2: protocol_unreachable
        3: port_unreachable
        4: fragmentation_needed_and_df_set
        5: source_route_failed
        6: dst_net_unknown
        7: sdt_host_unknown
        8: src_isolated
        9: net_prohibited_by_admin
        10: host_prohibited_by_admin
        11: net_unreachable_for_tos
        12: host_unreachable_for_tos
        13: communication_prohibited_by_admin
        14: host_precedence_violation
        15: precedence_cuttoff_in_effect
  time_exceeded_msg:
    seq:
      - id: code
        type: u1
        enum: time_exceeded_code
      - id: checksum
        type: u2
    enums:
      time_exceeded_code:
        0: time_to_live_exceeded_in_transit
        1: fragment_reassembly_time_exceeded
  echo_msg:
    seq:
      - id: code
        contents: [0]
      - id: checksum
        type: u2
      - id: identifier
        type: u2
      - id: seq_num
        type: u2
      - id: data
        size-eos: true
  redirect_msg:
    seq:
      - id: code
        type: u1
        enum: redirect_code
      - id: checksum
        type: u2
      - id: gateway_internet_address
        size: 4
        doc: |
          Address of the gateway to which traffic for the network specified
          in the original datagram should be sent
      - id: original_datagram
        size-eos: true
        doc: Internet header + 64 bits of the original datagram's data
    enums:
      redirect_code:
        0: redirect_for_network
        1: redirect_for_host
        2: redirect_for_tos_and_network
        3: redirect_for_tos_and_host
  parameter_problem_msg:
    seq:
      - id: code
        type: u1
        doc: 0 means `pointer` indicates the error
      - id: checksum
        type: u2
      - id: pointer
        type: u1
        doc: |
          Identifies the octet of the original datagram's header where an
          error was detected
      - id: unused
        size: 3
      - id: original_datagram
        size-eos: true
        doc: Internet header + 64 bits of the original datagram's data
  timestamp_msg:
    doc: Timestamp (type 13) or timestamp reply (type 14) message
    seq:
      - id: code
        contents: [0]
      - id: checksum
        type: u2
      - id: identifier
        type: u2
      - id: seq_num
        type: u2
      - id: originate_timestamp
        type: u4
        doc: |
          Time the sender last touched the message before sending it, in
          milliseconds since midnight UT
      - id: receive_timestamp
        type: u4
        doc: |
          Time the echoer first touched it on receipt, in milliseconds since
          midnight UT
      - id: transmit_timestamp
        type: u4
        doc: |
          Time the echoer last touched the message on sending it, in
          milliseconds since midnight UT
