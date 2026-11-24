# Imported from https://github.com/mombesam-unil/FLP-geolocation-analysis/blob/af64f437f83affe13f9ad6eea463e28dacb1b03e/docs/intermediate_traces/cache_structures/vtc_structure.ksy
meta:
  id: flp_vtc_cache
  title: VTC Cache (decrypted payload)
  application: Google Play services / FLP Wi-Fi RTT cache v2
  file-extension: vtc.dec
  license: MIT
  ks-version: '0.10'
  endian: be
doc: |
  Kaitai Struct schema for the decrypted VTC cache payload.

  This schema models the inner binary structure after AES/HMAC processing has
  already been removed. The encrypted outer wrapper is intentionally out of
  scope here.

  Observed layout:

  1. opaque helper block
  2. AP IDs for alias lists
  3. alias data
  4. opaque helper block
  5. AP IDs for RTT models
  6. RTT model protobuf data
  7. opaque helper block
  8. missing requested AP IDs

  The plaintext also contains an observed 36-byte trailing footer/signature
  area after the block sequence. This schema captures it as raw trailing data.

  Each block uses the same outer container:
  - uint32_be block_size
  - uint64_be block_checksum
  - block_size bytes of block data

seq:
  - id: block_1
    type: opaque_block
  - id: ap_ids_aliases_block
    type: ap_ids_block
  - id: alias_data_block
    type: alias_data_block(ap_ids_aliases_block.ap_count)
  - id: block_4
    type: opaque_block
  - id: ap_ids_rtt_block
    type: ap_ids_block
  - id: rtt_model_data_block
    type: rtt_model_data_block(ap_ids_rtt_block.ap_count)
  - id: block_7
    type: opaque_block
  - id: missing_requested_aps_block
    type: ap_ids_block
  - id: trailing_footer
    size-eos: true

types:
  opaque_block:
    doc: |
      Generic VTC block container used for the currently undocumented helper
      blocks.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: block_data
        size: block_size

  ap_ids_block:
    doc: |
      Block containing serialized AP identifiers. In VTC, these identifiers are
      plain 48-bit MAC/BSSID values stored in 8-byte fields.
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
    seq:
      - id: raw
        type: u8
    instances:
      serialized_mac:
        value: raw & 281474976710655

  alias_data_block:
    doc: |
      Block 3. Contains variable-length alias blobs aligned to the AP IDs in
      block 2.
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
        type: alias_data_payload(ap_count)

  alias_data_payload:
    params:
      - id: ap_count
        type: u4
    seq:
      - id: alias_lengths
        type: u4
        repeat: expr
        repeat-expr: ap_count
      - id: alias_blobs_raw
        size-eos: true

  rtt_model_data_block:
    doc: |
      Block 6. Contains variable-length protobuf RTT model blobs aligned to the
      AP IDs in block 5.
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
        type: rtt_model_data_payload(ap_count)

  rtt_model_data_payload:
    params:
      - id: ap_count
        type: u4
    seq:
      - id: model_lengths
        type: u4
        repeat: expr
        repeat-expr: ap_count
      - id: model_blobs_raw
        size-eos: true
