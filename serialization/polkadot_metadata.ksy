# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/metadata.ksy
meta:
  id: polkadot_metadata
  title: Metadata
  license: LicenseRef-All-Rights-Reserved
  imports:
    - polkadot_scale
    - polkadot_metadata_type
    - polkadot_metadata_pallet
    - polkadot_metadata_extrinsic
  endian: le
seq:
  - id: magic
    contents: meta
  - id: metadata_version
    type: u1

  - id: num_types
    type: polkadot_scale::compact_int
  - id: types
    type: polkadot_metadata_type
    repeat: expr
    repeat-expr: num_types.value

  - id: num_pallets
    type: polkadot_scale::compact_int
  - id: pallets
    type: polkadot_metadata_pallet
    repeat: expr
    repeat-expr: num_pallets.value

  - id: extrinsic_type
    type: polkadot_scale::compact_int
  - id: extrinsic_version
    type: u1
  - id: num_extrinsics
    type: polkadot_scale::compact_int
  - id: extrinsics
    type: polkadot_metadata_extrinsic
    repeat: expr
    repeat-expr: num_extrinsics.value

  - id: runtime_type
    type: polkadot_scale::compact_int
