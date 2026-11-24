# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/metadata_type_variants.ksy
meta:
  id: polkadot_metadata_type_variants
  title: MetadataTypeVariants
  license: GPL-3.0-only
  imports:
    - polkadot_scale
    - polkadot_metadata_type_fields
  endian: le
seq:
  - id: num_variants
    type: polkadot_scale::compact_int
  - id: variants
    type: variant
    repeat: expr
    repeat-expr: num_variants.value
types:
  variant:
    seq:
      - id: name
        type: polkadot_scale::string
      - id: composite
        type: polkadot_metadata_type_fields
      - id: index
        type: u1
      - id: docs
        type: polkadot_scale::string_list
