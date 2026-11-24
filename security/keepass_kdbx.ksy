meta:
  id: keepass_kdbx
  title: KeePass 2.x password database (KDBX 2/3/4)
  application:
    - KeePass 2.x
    - KeePassXC
  file-extension: kdbx
  license: CC0-1.0
  ks-version: '0.9'
  encoding: UTF-8
  endian: le
doc: |
  KDBX is the encrypted password database format of KeePass 2.x and
  compatible password managers such as KeePassXC.

  The file starts with two signatures and a format version, followed by a
  plain-text outer header made of type-length-value fields (cipher, master
  seed, IV, compression, key derivation parameters, ...). The rest of the
  file is the encrypted, optionally gzip-compressed XML database.

  * KDBX 2.x/3.x: header field lengths are 16-bit. The payload after the
    header is encrypted as a whole; after decryption it starts with
    `stream_start_bytes` followed by a hashed block stream.
  * KDBX 4.x: header field lengths are 32-bit, key derivation parameters
    are stored in a variant dictionary, and the header is followed by its
    SHA-256 hash, its HMAC-SHA-256 and the encrypted payload split into
    HMAC-protected blocks. The decrypted payload starts with an inner
    header (protected stream key, attachments) that is not covered here.

  This spec only describes the unencrypted structure; decryption needs the
  composite key and is out of scope. Legacy KeePass 1.x (KDB) files, whose
  second signature is 0xB54BFB65, are not covered.
doc-ref:
  - https://github.com/keepassxreboot/keepassxc/blob/develop/src/format/KeePass2.h
  - https://github.com/keepassxreboot/keepassxc/blob/develop/src/format/KdbxReader.cpp
  - https://github.com/keepassxreboot/keepassxc/blob/develop/src/format/Kdbx3Reader.cpp
  - https://github.com/keepassxreboot/keepassxc/blob/develop/src/format/Kdbx4Reader.cpp
  - https://github.com/keepassxreboot/keepassxc/blob/develop/src/streams/HmacBlockStream.cpp
seq:
  - id: magic1
    contents: [0x03, 0xd9, 0xa2, 0x9a]
    doc: 0x9AA2D903 (little-endian)
  - id: magic2
    contents: [0x67, 0xfb, 0x4b, 0xb5]
    doc: 0xB54BFB67 (little-endian), KeePass 2.x
  - id: version_minor
    type: u2
  - id: version_major
    type: u2
    valid:
      min: 2
      max: 4
  - id: header_fields
    type: header_field
    repeat: until
    repeat-until: _.id == header_field_id::end_of_header
  - id: header_sha256
    size: 32
    if: version_major >= 4
    doc: SHA-256 of all bytes from the start of the file to the end of the header.
  - id: header_hmac
    size: 32
    if: version_major >= 4
    doc: |
      HMAC-SHA-256 of the header (key derived from the master seed and the composite
      key).
  - id: blocks
    type: hmac_block
    repeat: until
    repeat-until: _.len_data == 0
    if: version_major >= 4
    doc: Encrypted payload as HMAC-protected blocks; the last block has length 0.
  - id: encrypted_payload
    size-eos: true
    if: version_major < 4
    doc: Encrypted payload (KDBX 2.x/3.x).
types:
  header_field:
    seq:
      - id: id
        type: u1
        enum: header_field_id
      - id: len_data
        type:
          switch-on: _root.version_major >= 4
          cases:
            true: u4
            false: u2
      - id: data
        size: len_data
        type:
          switch-on: id
          cases:
            header_field_id::compression_flags: compression_flags
            header_field_id::transform_rounds: transform_rounds
            header_field_id::inner_random_stream_id: inner_random_stream_id
            header_field_id::kdf_parameters: variant_dictionary
            header_field_id::public_custom_data: variant_dictionary
        doc: |
          Field data. Raw bytes for:

          * `comment`
          * `cipher_id`: 16-byte cipher UUID in RFC 4122 byte order:
            31c1f2e6-bf71-4350-be58-05216afc5aff = AES-256,
            61ab05a1-9464-41c3-8d74-3a563df8dd35 = AES-128,
            ad68f29f-576f-4bb9-a36a-d47af965346c = Twofish,
            d6038a2b-8b6f-4cb5-a524-339a31dbb59a = ChaCha20
          * `master_seed` (32 bytes)
          * `transform_seed` (32 bytes, KDBX 3 AES-KDF seed)
          * `encryption_iv`
          * `protected_stream_key` (KDBX 3)
          * `stream_start_bytes` (KDBX 3, 32 bytes)
          * `end_of_header` (usually "\r\n\r\n")
  compression_flags:
    seq:
      - id: algorithm
        type: u4
        enum: compression_algorithm
  transform_rounds:
    doc: Number of AES-KDF rounds (KDBX 3).
    seq:
      - id: rounds
        type: u8
  inner_random_stream_id:
    doc: Algorithm protecting in-memory protected values (KDBX 3).
    seq:
      - id: algorithm
        type: u4
        enum: protected_stream_algo
  variant_dictionary:
    doc: |
      Typed key-value map used for KDF parameters and public custom data
      (KDBX 4). KDF parameters always include `$UUID` (KDF UUID:
      c9d9f39a-628a-4460-bf74-0d08c18a4fea = AES-KDF (KDBX 3),
      7c02bb82-79a7-4ac0-927d-114a00648238 = AES-KDF (KDBX 4),
      ef636ddf-8c29-444b-91f7-a9a403e30a0c = Argon2d,
      9e298b19-56db-4773-b23d-fc3ec6f0a1e6 = Argon2id), and e.g. `R`/`S`
      for AES-KDF or `S`, `P`, `M`, `I`, `V` for Argon2.
    seq:
      - id: version
        type: u2
        doc: Format version; the high byte must be at most 1.
      - id: entries
        type: variant_entry
        repeat: until
        repeat-until: _.type == variant_type::end or _io.eof
  variant_entry:
    seq:
      - id: type
        type: u1
        enum: variant_type
      - id: len_name
        type: u4
        if: type != variant_type::end
      - id: name
        size: len_name
        type: str
        if: type != variant_type::end
      - id: len_value
        type: u4
        if: type != variant_type::end
      - id: value
        size: len_value
        type:
          switch-on: type
          cases:
            variant_type::uint32: variant_u4
            variant_type::uint64: variant_u8
            variant_type::bool: variant_bool
            variant_type::int32: variant_s4
            variant_type::int64: variant_s8
            variant_type::string: variant_str
        if: type != variant_type::end
        doc: Value; raw bytes for `byte_array`.
  variant_u4:
    seq:
      - id: value
        type: u4
  variant_u8:
    seq:
      - id: value
        type: u8
  variant_s4:
    seq:
      - id: value
        type: s4
  variant_s8:
    seq:
      - id: value
        type: s8
  variant_bool:
    seq:
      - id: value
        type: u1
    instances:
      is_true:
        value: value != 0
  variant_str:
    seq:
      - id: value
        size-eos: true
        type: str
  hmac_block:
    seq:
      - id: hmac
        size: 32
        doc: |
          HMAC-SHA-256 over the 64-bit block index, the block length and the
          block data, keyed per block.
      - id: len_data
        type: s4
        valid:
          min: 0
      - id: data
        size: len_data
        doc: Encrypted payload data.
enums:
  header_field_id:
    0: end_of_header
    1: comment
    2: cipher_id
    3: compression_flags
    4: master_seed
    5: transform_seed
    6: transform_rounds
    7: encryption_iv
    8: protected_stream_key
    9: stream_start_bytes
    10: inner_random_stream_id
    11: kdf_parameters
    12: public_custom_data
  compression_algorithm:
    0: none
    1: gzip
  protected_stream_algo:
    1: arc_four_variant
    2: salsa20
    3: chacha20
  variant_type:
    0x00: end
    0x04: uint32
    0x05: uint64
    0x08: bool
    0x0c: int32
    0x0d: int64
    0x18: string
    0x42: byte_array
