# Imported from https://github.com/simrossi/ech_scanner/blob/02f36f2fee004e93c9c21d212b5d203c40f955a7/ech_config.ksy
meta:
  id: tls_ech_config
  title: TLS Encrypted Client Hello (ECH) Config
  license: LicenseRef-All-Rights-Reserved
  endian: be

seq:
  - id: len_config
    type: u2
  - id: config
    size: len_config
    type: ech_config_struct

types:
  ech_config_struct:
    seq:
      - id: version
        type: u2
      - id: len_contents
        type: u2
      - id: contents
        size: len_contents
        type: ech_config_contents
        if: version == 0xfe0d # TLS 1.3 ECH version

  ech_config_contents:
    seq:
      - id: key_config
        type: hpke_key_config
      - id: maximum_name_length
        type: u1
      - id: public_name_length
        type: u1
      - id: public_name
        size: public_name_length
        type: str
        encoding: ASCII
      - id: extensions_length
        type: u2
      - id: extensions
        type: ech_config_extension
        repeat: eos
        if: extensions_length > 0

  hpke_key_config:
    seq:
      - id: config_id
        type: u1
      - id: kem_id # [RFC9180]
        type: u2
      - id: len_public_key
        type: u2
      - id: public_key
        size: len_public_key
      - id: cipher_suites_length
        type: u2
      - id: cipher_suites
        type: hpke_symmetric_cipher_suite
        repeat: expr
        repeat-expr: cipher_suites_length / 4

  hpke_symmetric_cipher_suite:
    seq:
      - id: kdf_id # [RFC9180]
        type: u2
      - id: aead_id # [RFC9180]
        type: u2

  ech_config_extension:
    seq:
      - id: extension_type
        type: u2
      - id: len_data
        type: u2
      - id: data
        size: len_data
