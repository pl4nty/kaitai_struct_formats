# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/pallet_constant.ksy
meta:
  id: polkadot_pallet_constant
  title: PalletConstant
  license: GPL-3.0-only
  imports:
    - polkadot_scale
  endian: le
seq:
  - id: name
    type: polkadot_scale::string
  - id: type
    type: polkadot_scale::compact_int
  - id: value
    type: polkadot_scale::bytes
  - id: docs
    type: polkadot_scale::string_list
