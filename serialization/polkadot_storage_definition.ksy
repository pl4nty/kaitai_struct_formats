# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/storage_definition.ksy
meta:
  id: polkadot_storage_definition
  title: StorageDefinition
  license: LicenseRef-All-Rights-Reserved
  imports:
    - polkadot_scale
  endian: le
seq:
  - id: type
    type: u1
    enum: storage_type
  - id: details
    type:
      switch-on: type
      cases:
        'storage_type::plain': plain
        'storage_type::map': map
enums:
  storage_type:
    0: plain
    1: map
types:
  plain:
    seq:
      - id: type
        type: polkadot_scale::compact_int
  map:
    seq:
      - id: num_hasher
        type: polkadot_scale::compact_int
      - id: hasher
        type: u1
        enum: hasher_type
        repeat: expr
        repeat-expr: num_hasher.value

      - id: key
        type: polkadot_scale::compact_int
      - id: value
        type: polkadot_scale::compact_int
    enums:
      hasher_type:
        0: blake2_128
        1: blake2_256
        2: blake2_128_128
        3: xxhash_128
        4: xxhash_256
        5: xxhahs_64_64
        6: idhash
