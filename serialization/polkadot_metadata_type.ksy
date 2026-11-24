# Imported from https://github.com/w3f/polkadot-spec/blob/3b1afed68372d1f6e2fdceb133f179c90fdd48ed/kaitai_structures/metadata_type.ksy
meta:
  id: polkadot_metadata_type
  title: MetadataType
  license: GPL-3.0-only
  imports:
    - polkadot_scale
    - polkadot_metadata_type_definition
  endian: le
seq:
  - id: id
    type: polkadot_scale::compact_int

  - id: path
    type: polkadot_scale::string_list

  - id: num_params
    type: polkadot_scale::compact_int
  - id: params
    type: param
    repeat: expr
    repeat-expr: num_params.value

  - id: definition
    type: polkadot_metadata_type_definition

  - id: docs
    type: polkadot_scale::string_list
types:
  param:
    seq:
      - id: name
        type: polkadot_scale::string
      - id: type
        type: polkadot_scale::maybe_compact_int
