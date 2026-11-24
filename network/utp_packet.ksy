meta:
  id: utp_packet
  title: uTorrent Transport Protocol (uTP) packet
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  uTP (Micro Transport Protocol, BitTorrent BEP 29) is a reliable,
  ordered transport with delay-based congestion control, carried in
  UDP datagrams. Every packet starts with a 20-byte version 1 header
  (packet type, protocol version, first extension type, connection ID,
  timestamps, advertised receive window, sequence and acknowledgement
  numbers), optionally followed by a linked list of extension headers,
  followed by the payload (data for ST_DATA packets).

  This spec parses one UDP payload (one uTP packet). The only
  extensions defined are selective ACK (type 1) and, in libutp, the
  "extension bits" sent in SYN packets (type 2, 8 bytes).
doc-ref:
  - https://www.bittorrent.org/beps/bep_0029.html
  - https://github.com/bittorrent/libutp/blob/2b364cbb0650bdab64a5de2abb4518f9f228ec44/utp_internal.cpp
seq:
  - id: packet_type
    -orig-id: type
    type: b4
    enum: packet_types
  - id: version
    -orig-id: ver
    type: b4
    valid: 1
  - id: first_extension
    -orig-id: extension
    type: u1
    enum: extension_types
    doc: Type of the first extension header; `none` means there are no extensions.
  - id: connection_id
    type: u2
  - id: timestamp_microseconds
    type: u4
    doc: Microseconds part of the time the packet was sent.
  - id: timestamp_difference_microseconds
    type: u4
    doc: |
      Difference between the local time and the timestamp of the last
      received packet, when it was received (latest one-way delay sample).
  - id: wnd_size
    type: u4
    doc: Advertised receive window, in bytes.
  - id: seq_nr
    type: u2
  - id: ack_nr
    type: u2
  - id: extensions
    type: 'extension(_index == 0 ? first_extension : extensions[_index - 1].next_extension)'
    repeat: until
    repeat-until: _.next_extension == extension_types::none
    if: first_extension != extension_types::none
  - id: payload
    size-eos: true
types:
  extension:
    params:
      - id: extension_type
        type: u1
        enum: extension_types
        doc: Type of this extension, given by the previous header.
    seq:
      - id: next_extension
        -orig-id: extension
        type: u1
        enum: extension_types
      - id: len_body
        -orig-id: len
        type: u1
      - id: body
        size: len_body
        type:
          switch-on: extension_type
          cases:
            extension_types::selective_ack: selective_ack
  selective_ack:
    doc: |
      Bitmask (at least 32 bits, a multiple of 32) of received packets
      starting at `ack_nr + 2`. In each byte the least significant bit is
      the lowest sequence number, i.e. bit `i` of byte `j` acknowledges
      `ack_nr + 2 + 8 * j + i`.
    seq:
      - id: bitmask
        size-eos: true
enums:
  packet_types:
    0:
      id: st_data
      doc: Regular data packet; always carries a payload.
    1:
      id: st_fin
      doc: Finalize the connection; last sequence number of the connection.
    2:
      id: st_state
      doc: State packet, an ACK with no data.
    3:
      id: st_reset
      doc: Terminate the connection forcefully.
    4:
      id: st_syn
      doc: Connect SYN, initiates a connection.
  extension_types:
    0: none
    1: selective_ack
    2:
      id: extension_bits
      doc: libutp extension bits (8 bytes), sent with ST_SYN.
