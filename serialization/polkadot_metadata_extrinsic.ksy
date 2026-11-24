# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/metadata_extrinsic.ksy
meta:
  id: polkadot_metadata_extrinsic
  title: MetadataExtrinsic
  license: LicenseRef-All-Rights-Reserved
  imports:
    - polkadot_scale
  endian: le
seq:
  - id: name
    type: polkadot_scale::string
  - id: type
    type: polkadot_scale::compact_int
  - id: additional
    type: polkadot_scale::compact_int
