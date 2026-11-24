# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/metadata_type_fields.ksy
meta:
  id: polkadot_metadata_type_fields
  title: MetadataTypeFields
  license: LicenseRef-All-Rights-Reserved
  imports:
    - polkadot_scale
  endian: le
seq:
  - id: num_fields
    type: polkadot_scale::compact_int
  - id: fields
    type: field
    repeat: expr
    repeat-expr: num_fields.value
types:
  field:
    seq:
      - id: name
        type: polkadot_scale::maybe_string
      - id: type
        type: polkadot_scale::compact_int
      - id: typename
        type: polkadot_scale::maybe_string
      - id: docs
        type: polkadot_scale::string_list
