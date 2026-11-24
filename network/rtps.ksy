meta:
  id: rtps
  title: Real-Time Publish-Subscribe (RTPS) protocol 2.3
  license: LicenseRef-All-Rights-Reserved
doc: |
  RTPS is the wire protocol that lets implementations of the Data
  Distribution Service (DDS) of different vendors talk to each other. It
  normally runs on top of UDP, one RTPS message per datagram.

  A message is a header followed by submessages. Each submessage says in
  the lowest bit of its flags whether its numbers are little or big endian.

  This spec covers versions 2.0 and later of the protocol; version 1 has a
  shorter header. Submessages that the standard does not define, such as
  the ones of DDS Security or of a vendor, are left as raw bytes.
doc-ref:
  - https://www.omg.org/spec/DDSI-RTPS/2.3/PDF
  - https://gitlab.com/wireshark/wireshark/-/blob/master/epan/dissectors/packet-rtps.c
seq:
  - id: header
    type: header
  - id: submessages
    type: submessage
    repeat: eos
types:
  header:
    seq:
      - id: magic
        contents: RTPS
      - id: protocol_version
        type: protocol_version
      - id: vendor_id
        size: 2
      - id: guid_prefix
        type: guid_prefix
  protocol_version:
    seq:
      - id: major
        type: u1
      - id: minor
        type: u1
  guid_prefix:
    seq:
      - id: host_id
        size: 4
      - id: app_id
        size: 4
      - id: instance_id
        size: 4
  entity_id:
    seq:
      - id: key
        size: 3
      - id: kind
        type: u1
  submessage:
    seq:
      - id: submessage_id
        type: u1
        enum: submessage_id
      - id: flags
        type: u1
      - id: body
        type: body
    instances:
      is_le:
        value: (flags & 0x01) != 0
        doc: EndiannessFlag (E).
    types:
      body:
        meta:
          endian:
            switch-on: _parent.flags & 0x01
            cases:
              0: be
              1: le
        seq:
          - id: octets_to_next_header
            type: u2
          - id: elements
            size: len_elements
            type:
              switch-on: _parent.submessage_id
              cases:
                'submessage_id::acknack': acknack
                'submessage_id::heartbeat': heartbeat
                'submessage_id::gap': gap
                'submessage_id::info_ts': info_timestamp
                'submessage_id::info_src': info_source
                'submessage_id::info_reply_ip4': info_reply_ip4
                'submessage_id::info_dst': info_destination
                'submessage_id::info_reply': info_reply
                'submessage_id::nack_frag': nack_frag
                'submessage_id::heartbeat_frag': heartbeat_frag
                'submessage_id::data': data
                'submessage_id::data_frag': data_frag
        instances:
          flags:
            value: _parent.flags
          is_last:
            value: >-
              octets_to_next_header == 0
              and _parent.submessage_id != submessage_id::pad
              and _parent.submessage_id != submessage_id::info_ts
            doc: |
              A length of 0 means that the submessage extends to the end of
              the message, except for the two kinds of submessages that can
              be empty.
          len_elements:
            value: 'is_last ? _io.size - _io.pos : octets_to_next_header'
        types:
          acknack:
            seq:
              - id: reader_id
                type: entity_id
              - id: writer_id
                type: entity_id
              - id: reader_sn_state
                type: sequence_number_set
              - id: count
                type: s4
            instances:
              is_final:
                value: (_parent.flags & 0x02) != 0
                doc: FinalFlag (F).
          heartbeat:
            seq:
              - id: reader_id
                type: entity_id
              - id: writer_id
                type: entity_id
              - id: first_sn
                type: sequence_number
              - id: last_sn
                type: sequence_number
              - id: count
                type: s4
            instances:
              is_final:
                value: (_parent.flags & 0x02) != 0
                doc: FinalFlag (F).
              is_liveliness:
                value: (_parent.flags & 0x04) != 0
                doc: LivelinessFlag (L).
          gap:
            seq:
              - id: reader_id
                type: entity_id
              - id: writer_id
                type: entity_id
              - id: gap_start
                type: sequence_number
              - id: gap_list
                type: sequence_number_set
          info_timestamp:
            seq:
              - id: timestamp
                type: timestamp
                if: not is_invalidate
            instances:
              is_invalidate:
                value: (_parent.flags & 0x02) != 0
                doc: |
                  InvalidateFlag (I): the following submessages have no
                  timestamp.
          info_source:
            seq:
              - id: unused
                type: u4
              - id: protocol_version
                type: protocol_version
              - id: vendor_id
                size: 2
              - id: guid_prefix
                type: guid_prefix
          info_reply_ip4:
            seq:
              - id: unicast_locator
                type: locator_udp_v4
              - id: multicast_locator
                type: locator_udp_v4
                if: has_multicast
            instances:
              has_multicast:
                value: (_parent.flags & 0x02) != 0
                doc: MulticastFlag (M).
          info_destination:
            seq:
              - id: guid_prefix
                type: guid_prefix
          info_reply:
            seq:
              - id: unicast_locator_list
                type: locator_list
              - id: multicast_locator_list
                type: locator_list
                if: has_multicast
            instances:
              has_multicast:
                value: (_parent.flags & 0x02) != 0
                doc: MulticastFlag (M).
          nack_frag:
            seq:
              - id: reader_id
                type: entity_id
              - id: writer_id
                type: entity_id
              - id: writer_sn
                type: sequence_number
              - id: fragment_number_state
                type: fragment_number_set
              - id: count
                type: s4
          heartbeat_frag:
            seq:
              - id: reader_id
                type: entity_id
              - id: writer_id
                type: entity_id
              - id: writer_sn
                type: sequence_number
              - id: last_fragment_num
                type: u4
              - id: count
                type: s4
          data:
            seq:
              - id: extra_flags
                type: u2
              - id: octets_to_inline_qos
                type: u2
                doc: |
                  Number of bytes between the end of this field and
                  `inline_qos`, normally 16.
              - id: reader_id
                type: entity_id
              - id: writer_id
                type: entity_id
              - id: writer_sn
                type: sequence_number
              - id: reserved
                size: octets_to_inline_qos - 16
              - id: inline_qos
                type: parameter_list
                if: has_inline_qos
              - id: serialized_payload
                size-eos: true
                type: serialized_payload
                if: has_data or has_key
            instances:
              has_inline_qos:
                value: (_parent.flags & 0x02) != 0
                doc: InlineQosFlag (Q).
              has_data:
                value: (_parent.flags & 0x04) != 0
                doc: DataFlag (D), the payload is the value of the data object.
              has_key:
                value: (_parent.flags & 0x08) != 0
                doc: KeyFlag (K), the payload is the key of the data object.
          data_frag:
            seq:
              - id: extra_flags
                type: u2
              - id: octets_to_inline_qos
                type: u2
                doc: |
                  Number of bytes between the end of this field and
                  `inline_qos`, normally 28.
              - id: reader_id
                type: entity_id
              - id: writer_id
                type: entity_id
              - id: writer_sn
                type: sequence_number
              - id: fragment_starting_num
                type: u4
                doc: Number of the first fragment in this submessage, from 1.
              - id: fragments_in_submessage
                type: u2
              - id: fragment_size
                type: u2
                doc: Size of every fragment but the last one, in bytes.
              - id: sample_size
                type: u4
                doc: Size of the whole payload before fragmentation, in bytes.
              - id: reserved
                size: octets_to_inline_qos - 28
              - id: inline_qos
                type: parameter_list
                if: has_inline_qos
              - id: serialized_payload
                size-eos: true
                doc: |
                  Consecutive fragments of a serialized payload; only the
                  first fragment starts with the payload header.
            instances:
              has_inline_qos:
                value: (_parent.flags & 0x02) != 0
                doc: InlineQosFlag (Q).
              has_key:
                value: (_parent.flags & 0x04) != 0
                doc: KeyFlag (K), the payload is the key of the data object.
          sequence_number:
            seq:
              - id: high
                type: s4
              - id: low
                type: u4
            instances:
              value:
                value: (high << 32) | low
          sequence_number_set:
            seq:
              - id: bitmap_base
                type: sequence_number
              - id: num_bits
                type: u4
              - id: bitmap
                type: u4
                repeat: expr
                repeat-expr: (num_bits + 31) / 32
                doc: |
                  The most significant bit of the first word stands for
                  `bitmap_base`, the next one for `bitmap_base + 1` etc.
          fragment_number_set:
            seq:
              - id: bitmap_base
                type: u4
              - id: num_bits
                type: u4
              - id: bitmap
                type: u4
                repeat: expr
                repeat-expr: (num_bits + 31) / 32
          timestamp:
            seq:
              - id: seconds
                type: u4
              - id: fraction
                type: u4
                doc: In units of 2^-32 seconds.
          locator:
            seq:
              - id: kind
                type: s4
                enum: locator_kind
              - id: port
                type: u4
              - id: address
                size: 16
                doc: |
                  IPv6 address, or an IPv4 address in the last 4 bytes with
                  the rest set to zero.
          locator_udp_v4:
            seq:
              - id: address
                type: u4
              - id: port
                type: u4
          locator_list:
            seq:
              - id: num_locators
                type: u4
              - id: locators
                type: locator
                repeat: expr
                repeat-expr: num_locators
          parameter_list:
            seq:
              - id: parameters
                type: parameter
                repeat: until
                repeat-until: _.parameter_id == parameter_id::sentinel
          parameter:
            seq:
              - id: parameter_id
                type: u2
                enum: parameter_id
              - id: len_value
                type: u2
                doc: Always a multiple of 4; meaningless in the sentinel.
              - id: value
                size: len_value
                if: parameter_id != parameter_id::sentinel
          serialized_payload:
            seq:
              - id: representation_identifier
                type: u2be
                enum: representation_identifier
                doc: |
                  Tells how `data` is encoded, including its byte order,
                  which does not depend on the one of the submessage.
              - id: representation_options
                size: 2
              - id: data
                size-eos: true
enums:
  submessage_id:
    0x01: pad
    0x06: acknack
    0x07: heartbeat
    0x08: gap
    0x09: info_ts
    0x0c: info_src
    0x0d: info_reply_ip4
    0x0e: info_dst
    0x0f: info_reply
    0x12: nack_frag
    0x13: heartbeat_frag
    0x15: data
    0x16: data_frag
  locator_kind:
    -1: invalid
    0: reserved
    1: udp_v4
    2: udp_v6
  parameter_id:
    0x00: pad
    0x01: sentinel
    0x55: content_filter_info
    0x56: coherent_set
    0x57: directed_write
    0x61: original_writer_info
    0x70: key_hash
    0x71: status_info
  representation_identifier:
    0x0000: cdr_be
    0x0001: cdr_le
    0x0002: pl_cdr_be
    0x0003: pl_cdr_le
    0x0006: cdr2_be
    0x0007: cdr2_le
    0x0008: d_cdr2_be
    0x0009: d_cdr2_le
    0x000a: pl_cdr2_be
    0x000b: pl_cdr2_le
