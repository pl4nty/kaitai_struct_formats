# Imported from https://github.com/PatrikH0lop/kaitai-ssh/blob/4f44520683b2ae83bc71036a22966a2e99209352/parser.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ssh_transport
  title: SSH protocol parser by Patrik Holop.
  file-extension: bin
  xref:
    rfc: 4253
  license: MIT
  encoding: UTF-8
  endian: be


doc: Parser of the SSH protocol in Kaitai.
doc-ref: https://tools.ietf.org/html/rfc4253


seq:
  # Type of the message, either ssh identification string
  # or SSH packet.
  - id: ssh_idstring_or_packet_length
    type: b32
  - id: body
    type:
      switch-on: ssh_idstring_or_packet_length
      cases:
        # '[0x53, 0x53, 0x48, 0x2d]' is SSH banner.
        0x5353482D: identification_string
        _: ssh_packet


types:
  # SSH identification string.
  identification_string:
    seq:
      - id: protoversion
        type: str
        terminator: 0x2d
        encoding: UTF-8
      - id: additional_information
        type: additional_ssh_id_string_data
        terminator: 0x0d
        consume: false
      - id: cr
        contents: [0x0d]
      - id: lf
        contents: [0x0a]

  additional_ssh_id_string_data:
    seq:
      - id: softwareversion
        type: str
        terminator: 0x20
        eos-error: false
        encoding: UTF-8
      - id: comment
        size-eos: true
        type: str
        terminator: 0x0a
        encoding: UTF-8

  # SSH packet.
  ssh_packet:
    seq:
      - id: padding_length
        type: u1
      - id: payload
        type: payload

  # Payload of the message.
  payload:
    seq:
      - id: message_number
        type: u1
        enum: message_numbers
      - id: payload_specific_type
        type:
          switch-on: message_number
          cases:
            'message_numbers::ssh_msg_kexinit': key_exchange_init
            'message_numbers::ssh_msg_newkeys': key_exchange_new_keys
            'message_numbers::ssh_msg_kexdh_init': diffie_helman_init
            'message_numbers::ssh_msg_kexdg_reply': diffie_helman_reply
            'message_numbers::ssh_msg_disconnect': msg_disconnect
            'message_numbers::ssh_msg_debug': msg_debug
            'message_numbers::ssh_msg_unimplemented': msg_unimplemented
            _: encrypted_data

  # Encrypted payload.
  encrypted_data:
    seq:
      - id: encrypted_message
        size: _root.ssh_idstring_or_packet_length-2
      - id: mac
        size: 16

  # Payload for exchanging of keys: client init.
  key_exchange_init:
    seq:
      - id: cookie
        size: 16
      - id: kex_algorithms_length
        type: u4
      - id: kex_algorithms
        size: kex_algorithms_length
        type: algorithm_list
      - id: server_host_key_algorithms_length
        type: u4
      - id: server_host_key_algorithms
        size: server_host_key_algorithms_length
        type: algorithm_list
      - id: encryption_algorithms_client_to_server_length
        type: u4
      - id: encryption_algorithms_client_to_server
        size: encryption_algorithms_client_to_server_length
        type: algorithm_list
      - id: encryption_algorithms_server_to_client_length
        type: u4
      - id: encryption_algorithms_server_to_client
        size: encryption_algorithms_server_to_client_length
        type: algorithm_list
      - id: mac_algorithms_client_to_server_length
        type: u4
      - id: mac_algorithms_client_to_server
        size: mac_algorithms_client_to_server_length
        type: algorithm_list
      - id: mac_algorithms_server_to_client_length
        type: u4
      - id: mac_algorithms_server_to_client
        size: mac_algorithms_server_to_client_length
        type: algorithm_list
      - id: compression_algorithms_client_to_server_length
        type: u4
      - id: compression_algorithms_client_to_server
        size: compression_algorithms_client_to_server_length
        type: algorithm_list
      - id: compression_algorithms_server_to_client_length
        type: u4
      - id: compression_algorithms_server_to_client
        size: compression_algorithms_server_to_client_length
        type: algorithm_list
      - id: languages_client_to_server_length
        type: u4
      - id: languages_client_to_server
        size: languages_client_to_server_length
        type: algorithm_list
      - id: languages_server_to_client_length
        type: u4
      - id: languages_server_to_client
        size: languages_server_to_client_length
        type: algorithm_list
      - id: first_kex_packet_follows
        type: u1
      - id: reserved_for_future_extension
        type: u4
      - id: random_padding
        size: _parent._parent.padding_length
  
  # SSH message for exhanging new keys.
  key_exchange_new_keys:
    seq:
      - id: random_padding
        size: _parent._parent.padding_length

  # Diffie helman algorithm init.
  diffie_helman_init:
    seq:
      - id: multi_precision_integer_length
        type: u4
      - id: e
        size: multi_precision_integer_length
      - id: random_padding
        size: _parent._parent.padding_length
  
  # Diffie helman algorithm reply.
  diffie_helman_reply:
    seq:
      - id: host_key_length
        type: u4
      - id: host_key_type_length
        type: u4
      - id: host_key_type
        size: host_key_type_length
        type: str
        encoding: UTF-8
      - id: ecdsa_elliptic_curve_identifier_length
        type: u4
      - id: ecdsa_ellipitic_curve_identifier
        size: ecdsa_elliptic_curve_identifier_length
        type: str
        encoding: UTF-8
      - id: ecdsa_public_key_length
        type: u4
      - id: ecdsa_public_key
        size: ecdsa_public_key_length
      - id: multi_precision_integer_length
        type: u4
      - id: f
        size: multi_precision_integer_length
      - id: signature_of_h_length
        type: u4
      - id: signature_of_h
        size: signature_of_h_length
      - id: random_padding
        size: _parent._parent.padding_length

  # List of algorithms for key exchange.
  algorithm_list:
    seq:
      - id: algorithm
        type: str
        terminator: 0x2c
        eos-error: false
        encoding: UTF-8
        repeat: eos

  # Disconnection message.
  msg_disconnect:
    seq:
      - id: reason_code
        type: u4
        enum: disconnection_message
      - id: description
        type: str
        terminator: 0x00
        encoding: UTF-8
      - id: language_tag
        type: str
        terminator: 0x00
        encoding: UTF-8
      - id: random_padding
        size: _parent._parent.padding_length

  # SSH debug messages.
  msg_debug:
    seq:
      - id: always_display
        type: u1
      - id: description
        type: str
        terminator: 0x00
        encoding: UTF-8
      - id: language_tag
        type: str
        terminator: 0x00
        encoding: UTF-8
      - id: random_padding
        size: _parent._parent.padding_length

  # SSH unimplemented messages.
  msg_unimplemented:
    seq:
      - id: packet_sequence_of_rejected_message
        type: u4
      - id: random_padding
        size: _parent._parent.padding_length


enums:
  # SSH message variants.
  message_numbers:
    1: ssh_msg_disconnect
    2: ssh_msg_ignore
    3: ssh_msg_unimplemented
    4: ssh_msg_debug
    5: ssh_msg_service_request
    6: ssh_msg_service_accept
    20: ssh_msg_kexinit
    21: ssh_msg_newkeys
    30: ssh_msg_kexdh_init
    31: ssh_msg_kexdg_reply

  # SSH disconnection variants.
  disconnection_message:
    1: ssh_disconnect_host_not_allowed_to_connect
    2: ssh_disconnect_protocol_error
    3: ssh_disconnect_key_exchange_failed
    4: ssh_disconnect_reserved
    5: ssh_disconnect_mac_error
    6: ssh_disconnect_compression_error
    7: ssh_disconnect_not_available
    8: ssh_disconnect_version_not_supported
    9: ssh_disconnect_key_not_verifiable
    10: ssh_disconnect_connection_lost
    11: ssh_disconnect_by_application
    12: ssh_disconnect_too_many_connections
    13: ssh_disconnect_auth_cancelled_by_user
    14: ssh_disconnect_auth_methods_available
    15: ssh_disconnect_illegal_user_name
