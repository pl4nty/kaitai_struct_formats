meta:
  id: tls_client_hello
  xref:
    rfc: 5246 # TLS 1.2
    wikidata: Q206494 # TLS
  license: MIT
  endian: be

seq:
  - id: version
    type: version

  - id: random
    type: random

  - id: session_id
    type: session_id

  - id: cipher_suites
    type: cipher_suites

  - id: compression_methods
    type: compression_methods

  - id: extensions
    type: extensions
    if: _io.eof == false

types:
  version:
    seq:
      - id: major
        type: u1

      - id: minor
        type: u1

  random:
    seq:
      - id: gmt_unix_time
        type: u4

      - id: random
        size: 28

  session_id:
    seq:
      - id: len
        type: u1

      - id: sid
        size: len

  cipher_suites:
    seq:
      - id: len
        type: u2

      - id: cipher_suites
        type: u2
        repeat: expr
        repeat-expr: len/2

  compression_methods:
    seq:
      - id: len
        type: u1

      - id: compression_methods
        size: len

  extensions:
    seq:
      - id: len
        type: u2

      - id: extensions
        type: extension
        repeat: eos

  extension:
    seq:
      - id: type
        type: u2
        enum: extension_type

      - id: len
        type: u2

      - id: body
        size: len
        type:
          switch-on: type
          cases:
            'extension_type::server_name': sni
            'extension_type::application_layer_protocol_negotiation': alpn
            'extension_type::supported_groups': supported_groups
            'extension_type::signature_algorithms': signature_algorithms
            'extension_type::supported_versions': supported_versions
            'extension_type::psk_key_exchange_modes': psk_key_exchange_modes
            'extension_type::key_share': key_share

  sni:
    seq:
      - id: list_length
        type: u2

      - id: server_names
        type: server_name
        repeat: eos

  server_name:
    seq:
      - id: name_type
        type: u1

      - id: length
        type: u2

      - id: host_name
        size: length

  alpn:
    seq:
      - id: ext_len
        type: u2

      - id: alpn_protocols
        type: protocol
        repeat: eos

  protocol:
    seq:
      - id: strlen
        type: u1

      - id: name
        size: strlen

  supported_groups:
    doc-ref: https://www.rfc-editor.org/rfc/rfc8446#section-4.2.7
    seq:
      - id: len
        type: u2

      - id: groups
        type: u2
        enum: named_group
        repeat: expr
        repeat-expr: len / 2

  signature_algorithms:
    doc: |
      Body of both the `signature_algorithms` and (not parsed here)
      `signature_algorithms_cert` extensions.
    doc-ref: https://www.rfc-editor.org/rfc/rfc8446#section-4.2.3
    seq:
      - id: len
        type: u2

      - id: algorithms
        type: u2
        enum: signature_scheme
        repeat: expr
        repeat-expr: len / 2

  supported_versions:
    doc: List of supported versions, as sent in a ClientHello.
    doc-ref: https://www.rfc-editor.org/rfc/rfc8446#section-4.2.1
    seq:
      - id: len
        type: u1

      - id: versions
        type: version
        repeat: expr
        repeat-expr: len / 2

  psk_key_exchange_modes:
    doc-ref: https://www.rfc-editor.org/rfc/rfc8446#section-4.2.9
    seq:
      - id: len
        type: u1

      - id: modes
        type: u1
        enum: psk_key_exchange_mode
        repeat: expr
        repeat-expr: len

  key_share:
    doc: Key shares, as sent in a ClientHello.
    doc-ref: https://www.rfc-editor.org/rfc/rfc8446#section-4.2.8
    seq:
      - id: len
        type: u2

      - id: client_shares
        type: key_share_entry
        repeat: eos

  key_share_entry:
    seq:
      - id: group
        type: u2
        enum: named_group

      - id: len_key_exchange
        type: u2

      - id: key_exchange
        size: len_key_exchange

enums:
  extension_type:
    0: server_name
    1: max_fragment_length
    5: status_request
    10: supported_groups
    11: ec_point_formats
    13: signature_algorithms
    14: use_srtp
    15: heartbeat
    16: application_layer_protocol_negotiation
    17: status_request_v2
    18: signed_certificate_timestamp
    21: padding
    22: encrypt_then_mac
    23: extended_master_secret
    27: compress_certificate
    28: record_size_limit
    35: session_ticket
    41: pre_shared_key
    42: early_data
    43: supported_versions
    44: cookie
    45: psk_key_exchange_modes
    49: post_handshake_auth
    50: signature_algorithms_cert
    51: key_share
    0xff01: renegotiation_info

  named_group:
    0x0017: secp256r1
    0x0018: secp384r1
    0x0019: secp521r1
    0x001d: x25519
    0x001e: x448
    0x0100: ffdhe2048
    0x0101: ffdhe3072
    0x0102: ffdhe4096
    0x0103: ffdhe6144
    0x0104: ffdhe8192
    0x11ec: x25519_mlkem768

  signature_scheme:
    0x0201: rsa_pkcs1_sha1
    0x0203: ecdsa_sha1
    0x0401: rsa_pkcs1_sha256
    0x0403: ecdsa_secp256r1_sha256
    0x0501: rsa_pkcs1_sha384
    0x0503: ecdsa_secp384r1_sha384
    0x0601: rsa_pkcs1_sha512
    0x0603: ecdsa_secp521r1_sha512
    0x0804: rsa_pss_rsae_sha256
    0x0805: rsa_pss_rsae_sha384
    0x0806: rsa_pss_rsae_sha512
    0x0807: ed25519
    0x0808: ed448
    0x0809: rsa_pss_pss_sha256
    0x080a: rsa_pss_pss_sha384
    0x080b: rsa_pss_pss_sha512

  psk_key_exchange_mode:
    0: psk_ke
    1: psk_dhe_ke
