# Imported from https://github.com/mombesam-unil/FLP-geolocation-analysis/blob/af64f437f83affe13f9ad6eea463e28dacb1b03e/docs/intermediate_traces/cache_structures/ftc_structure.ksy
# Licence and copyright: see _community/README.md
meta:
  id: flp_ftc_cache
  title: FTC Cache (decrypted payload)
  application: Google Play services / FLP Wi-Fi AP cache v2
  file-extension: ftc.dec
  license: MIT
  ks-version: '0.10'
  endian: be
doc: |
  Kaitai Struct schema for the decrypted FTC cache payload.

  This schema models the inner binary structure after AES/HMAC processing has
  already been removed. The encrypted outer wrapper is intentionally out of
  scope here.

  Observed layout:

  1. opaque helper block
  2. AP IDs
  3. AP data
  4. opaque helper block
  5. uninformative AP IDs
  6. opaque helper block
  7. tile IDs
  8. tile data
  9. opaque helper block
  10. floor model IDs
  11. floor model data
  12. opaque helper block
  13. building IDs
  14. building data

  Each block uses the same outer container:
  - uint32_be block_size
  - uint64_be block_checksum
  - block_size bytes of block data

seq:
  - id: block_1
    type: opaque_block
  - id: ap_ids_block
    type: ap_ids_block
  - id: ap_data_block
    type: ap_data_block(ap_ids_block.ap_count)
  - id: block_4
    type: opaque_block
  - id: uninformative_ap_ids_block
    type: uninformative_ap_ids_block
  - id: block_6
    type: opaque_block
  - id: tile_ids_block
    type: tile_ids_block
  - id: tile_data_block
    type: tile_data_block(tile_ids_block.tile_count)
  - id: block_9
    type: opaque_block
  - id: floor_model_ids_block
    type: floor_model_ids_block
  - id: floor_model_data_block
    type: floor_model_data_block(floor_model_ids_block.floor_count)
  - id: block_12
    type: opaque_block
  - id: building_ids_block
    type: building_ids_block
  - id: building_data_block
    type: building_data_block(building_ids_block.building_count)

types:
  opaque_block:
    doc: |
      Generic FTC block container used for the currently undocumented helper
      blocks.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: block_data
        size: block_size

  ap_ids_block:
    doc: Block 2. Contains serialized informative AP identifiers.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: ids
        type: ap_id
        repeat: expr
        repeat-expr: block_size / 8
    instances:
      ap_count:
        value: ids.size

  ap_id:
    doc: |
      One serialized AP identifier. Upper 16 bits encode tile_id, lower 48 bits
      encode the serialized BSSID / MAC address.
    seq:
      - id: raw
        type: u8
    instances:
      tile_id:
        value: raw >> 48
      serialized_mac:
        value: raw & 281474976710655

  ap_data_block:
    doc: Block 3. Contains AP-specific Wi-Fi model parameters aligned to block 2.
    params:
      - id: ap_count
        type: u4
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: payload
        size: block_size
        type: ap_data_payload(ap_count)

  ap_data_payload:
    params:
      - id: ap_count
        type: u4
    seq:
      - id: s2_suffixes
        type: u4
        repeat: expr
        repeat-expr: ap_count
      - id: power_outputs
        type: s1
        repeat: expr
        repeat-expr: ap_count
      - id: path_loss_exponents_raw
        type: s1
        repeat: expr
        repeat-expr: ap_count
      - id: model_user_elevations_specific_raw
        type: s2
        repeat: expr
        repeat-expr: ap_count
      - id: ap_floor_ids_raw
        type: u2
        repeat: expr
        repeat-expr: ap_count

  uninformative_ap_ids_block:
    doc: Block 5. Contains serialized uninformative AP identifiers.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: ids
        type: ap_id
        repeat: expr
        repeat-expr: block_size / 8
    instances:
      ap_count:
        value: ids.size

  tile_ids_block:
    doc: |
      Block 7. Contains tile identifiers used by AP, floor, and building
      records.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: tile_ids
        type: u2
        repeat: expr
        repeat-expr: block_size / 2
    instances:
      tile_count:
        value: tile_ids.size

  tile_data_block:
    doc: Block 8. Contains tile-level metadata aligned to block 7.
    params:
      - id: tile_count
        type: u4
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: payload
        size: block_size
        type: tile_data_payload(tile_count)

  tile_data_payload:
    params:
      - id: tile_count
        type: u4
    seq:
      - id: unknown_tile_short
        type: u2
        repeat: expr
        repeat-expr: tile_count
      - id: general_s2_cell_ids
        type: u8
        repeat: expr
        repeat-expr: tile_count
      - id: timestamps
        type: u8
        repeat: expr
        repeat-expr: tile_count
      - id: model_elevation_m_general
        type: u4
        repeat: expr
        repeat-expr: tile_count
      - id: unknown_general
        type: u4
        repeat: expr
        repeat-expr: tile_count

  floor_model_ids_block:
    doc: |
      Block 10. Contains floor-model identifiers. Upper 16 bits encode tile_id,
      lower 16 bits encode floor_local_id.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: ids
        type: floor_model_id
        repeat: expr
        repeat-expr: block_size / 4
    instances:
      floor_count:
        value: ids.size

  floor_model_id:
    seq:
      - id: raw
        type: u4
    instances:
      tile_id:
        value: raw >> 16
      floor_local_id:
        value: raw & 65535

  floor_model_data_block:
    doc: Block 11. Contains floor metadata aligned to block 10.
    params:
      - id: floor_count
        type: u4
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: payload
        size: block_size
        type: floor_model_data_payload(floor_count)

  floor_model_data_payload:
    params:
      - id: floor_count
        type: u4
    seq:
      - id: floor_labels
        type: floor_label
        repeat: expr
        repeat-expr: floor_count
      - id: floor_building_ids
        type: u2
        repeat: expr
        repeat-expr: floor_count
      - id: floor_unknown_short
        type: u2
        repeat: expr
        repeat-expr: floor_count
      - id: floor_s2_cell_ids
        type: u8
        repeat: expr
        repeat-expr: floor_count
      - id: floor_feature_ids
        type: u8
        repeat: expr
        repeat-expr: floor_count

  floor_label:
    doc: One 3-byte floor label, typically ASCII and often right-padded with NUL.
    seq:
      - id: raw
        size: 3

  building_ids_block:
    doc: |
      Block 13. Contains building identifiers. Upper 16 bits encode tile_id,
      lower 16 bits encode building_local_id.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: ids
        type: building_id
        repeat: expr
        repeat-expr: block_size / 4
    instances:
      building_count:
        value: ids.size

  building_id:
    seq:
      - id: raw
        type: u4
    instances:
      tile_id:
        value: raw >> 16
      building_local_id:
        value: raw & 65535

  building_data_block:
    doc: Block 14. Contains building metadata aligned to block 13.
    params:
      - id: building_count
        type: u4
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: payload
        size: block_size
        type: building_data_payload(building_count)

  building_data_payload:
    params:
      - id: building_count
        type: u4
    seq:
      - id: building_s2_cell_ids
        type: u8
        repeat: expr
        repeat-expr: building_count
      - id: building_feature_ids
        type: u8
        repeat: expr
        repeat-expr: building_count
