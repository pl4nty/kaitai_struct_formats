# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/metadata_pallet.ksy
meta:
  id: polkadot_metadata_pallet
  title: MetadataPallet
  license: LicenseRef-All-Rights-Reserved
  imports:
    - polkadot_scale
    - polkadot_pallet_storage
    - polkadot_pallet_constant
  endian: le
seq:
  - id: name
    type: polkadot_scale::string

  - id: has_storage
    type: u1
  - id: storage
    type: polkadot_pallet_storage
    if: has_storage != 0

  - id: has_calls
    type: u1
  - id: calls
    type: calls
    if: has_calls != 0

  - id: has_events
    type: u1
  - id: events
    type: events
    if: has_events != 0

  - id: num_constants
    type: polkadot_scale::compact_int
  - id: constants
    type: polkadot_pallet_constant
    repeat: expr
    repeat-expr: num_constants.value

  - id: has_errors
    type: u1
  - id: errors
    type: errors
    if: has_errors != 0

  - id: index
    type: u1
types:
  calls:
    seq:
      - id: type
        type: polkadot_scale::compact_int

  events:
    seq:
      - id: type
        type: polkadot_scale::compact_int

  errors:
    seq:
      - id: type
        type: polkadot_scale::compact_int
