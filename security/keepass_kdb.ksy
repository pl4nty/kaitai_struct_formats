meta:
  id: keepass_kdb
  title: KeePass 1.x password database (KDB)
  application:
    - KeePass 1.x
    - KeePassX
    - KeePassXC (import)
  file-extension: kdb
  license: CC0-1.0
  ks-version: '0.9'
  encoding: UTF-8
  endian: le
doc: |
  Password database of KeePass 1.x (and KeePassX before 2.0). The file
  is a fixed 124-byte plaintext header followed by the database body
  encrypted with AES-256 or Twofish in CBC mode (PKCS 7 padding).

  The key is derived from the password and/or key file: the 32-byte
  composite key is encrypted `transform_rounds` times with AES-256-ECB
  keyed by `transform_seed`, hashed with SHA-256, and the final key is
  SHA-256(`master_seed` + transformed key). `content_hash` is the
  SHA-256 of the decrypted body.

  The decrypted body (type `payload`, to be used on the decrypted
  bytes with the header's `num_groups` and `num_entries`) is a list of
  group records followed by entry records, each a sequence of
  `(type, size, data)` fields terminated by a field of type 0xFFFF.
doc-ref:
  - https://github.com/keepassxreboot/keepassxc/blob/cd42236540c1cfca332c0f051d981acfdacf7b4e/src/format/KeePass1Reader.cpp
  - https://github.com/keepassxreboot/keepassxc/blob/cd42236540c1cfca332c0f051d981acfdacf7b4e/src/format/KeePass1.h
seq:
  - id: header
    type: header
  - id: encrypted_body
    size-eos: true
types:
  header:
    seq:
      - id: signature1
        contents: [0x03, 0xd9, 0xa2, 0x9a]
        doc: u4 0x9AA2D903.
      - id: signature2
        contents: [0x65, 0xfb, 0x4b, 0xb5]
        doc: u4 0xB54BFB65.
      - id: flags
        type: u4
        doc: Encryption algorithm flags; see `is_rijndael` and `is_twofish`.
      - id: version
        type: u4
        doc: 0x00030002 for current files; readers check only the top 24 bits.
      - id: master_seed
        size: 16
      - id: encryption_iv
        size: 16
      - id: num_groups
        type: u4
      - id: num_entries
        type: u4
      - id: content_hash
        size: 32
        doc: SHA-256 of the decrypted body.
      - id: transform_seed
        size: 32
      - id: transform_rounds
        type: u4
    instances:
      is_rijndael:
        value: flags & 2 != 0
        doc: Body encrypted with AES-256-CBC.
      is_twofish:
        value: flags & 8 != 0
        doc: Body encrypted with Twofish-CBC.
  # ksylint: disable-next-line=KSY600 -- applies to the decrypted body
  payload:
    params:
      - id: num_groups
        type: u4
      - id: num_entries
        type: u4
    seq:
      - id: groups
        type: record(false)
        repeat: expr
        repeat-expr: num_groups
      - id: entries
        type: record(true)
        repeat: expr
        repeat-expr: num_entries
  record:
    params:
      - id: is_entry
        type: bool
    seq:
      - id: fields
        type: field(is_entry)
        repeat: until
        repeat-until: _.field_type == 0xffff
  field:
    params:
      - id: is_entry
        type: bool
    seq:
      - id: field_type
        type: u2
        doc: Meaning depends on the record kind; see `group_field` / `entry_field`.
      - id: len_data
        type: u4
      - id: data
        size: len_data
        type:
          switch-on: '(is_entry ? 0x10000 : 0) | field_type'
          cases:
            0x0002: c_string
            0x0003: packed_date
            0x0004: packed_date
            0x0005: packed_date
            0x0006: packed_date
            0x10004: c_string
            0x10005: c_string
            0x10006: c_string
            0x10007: c_string
            0x10008: c_string
            0x10009: packed_date
            0x1000a: packed_date
            0x1000b: packed_date
            0x1000c: packed_date
            0x1000d: c_string
    instances:
      group_field:
        value: field_type
        enum: group_fields
        if: not is_entry
      entry_field:
        value: field_type
        enum: entry_fields
        if: is_entry
  c_string:
    doc: NUL-terminated UTF-8 string.
    seq:
      - id: value
        type: strz
  packed_date:
    doc: |
      Date and time packed big-endian into 40 bits. 2999-12-28 23:59:59
      means "never".
    seq:
      - id: year
        type: b14
      - id: month
        type: b4
      - id: day
        type: b5
      - id: hour
        type: b5
      - id: minute
        type: b6
      - id: second
        type: b6
enums:
  group_fields:
    0x0000: ignore
    0x0001: group_id
    0x0002: name
    0x0003: creation_time
    0x0004: last_modification_time
    0x0005: last_access_time
    0x0006: expiry_time
    0x0007: icon
    0x0008: level
    0x0009: flags
    0xffff: end
  entry_fields:
    0x0000: ignore
    0x0001: uuid
    0x0002: group_id
    0x0003: icon
    0x0004: title
    0x0005: url
    0x0006: username
    0x0007: password
    0x0008: notes
    0x0009: creation_time
    0x000a: last_modification_time
    0x000b: last_access_time
    0x000c: expiry_time
    0x000d: binary_description
    0x000e: binary_data
    0xffff: end
