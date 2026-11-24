# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/pallet_storage.ksy
meta:
  id: polkadot_pallet_storage
  title: PalletStorage
  license: GPL-3.0-only
  imports:
    - polkadot_scale
    - polkadot_storage_definition
  endian: le
seq:
  - id: prefix
    type: polkadot_scale::string

  - id: num_items
    type: polkadot_scale::compact_int
  - id: items
    type: item
    repeat: expr
    repeat-expr: num_items.value
types:
  item:
    seq:
      - id: name
        type: polkadot_scale::string

      - id: modifier
        type: u1
        enum: storage_modifier

      - id: definition
        type: polkadot_storage_definition

      - id: fallback
        type: polkadot_scale::bytes

      - id: docs
        type: polkadot_scale::string_list
    enums:
      storage_modifier:
        0: optional
        1: default
