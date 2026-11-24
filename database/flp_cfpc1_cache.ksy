# Imported from https://github.com/mombesam-unil/FLP-geolocation-analysis/blob/af64f437f83affe13f9ad6eea463e28dacb1b03e/docs/intermediate_traces/cache_structures/cfpc1_structure.ksy
meta:
  id: flp_cfpc1_cache
  title: CFPC1 Cache (decrypted payload)
  application: Google Play services / FLP cell-based geolocation cache
  file-extension: cfpc1.dec
  license: MIT
  ks-version: '0.10'
  endian: be
doc: |
  Kaitai Struct schema for the decrypted CFPC1 cache payload.

  This schema models the inner binary structure after AES/HMAC processing has
  already been removed. The encrypted outer wrapper is intentionally out of
  scope here.

  Observed layout:

  1. hashset block
  2. cell IDs block
  3. cell data block

  Each block uses the same container:
  - uint32_be block_size
  - uint64_be block_checksum
  - block_size bytes of block data

seq:
  - id: hashset_block
    type: opaque_block
  - id: cell_ids_block
    type: cell_ids_block
  - id: cell_data_block
    type: cell_data_block(cell_ids_block.cell_id_count)

types:
  opaque_block:
    doc: |
      Generic CFPC1 block container used for the first "hashset" block, whose
      internal payload is still undocumented.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: block_data
        size: block_size

  cell_ids_block:
    doc: Second CFPC1 block. Contains the serialized serving-cell identifiers.
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: ids
        type: u8
        repeat: expr
        repeat-expr: block_size / 8
    instances:
      cell_id_count:
        value: ids.size

  cell_data_block:
    doc: |
      Third CFPC1 block. Contains timestamps and parameter blobs aligned by
      index to the cell identifiers from block 2.
    params:
      - id: cell_count
        type: u4
    seq:
      - id: block_size
        type: u4
      - id: block_checksum
        type: u8
      - id: payload
        size: block_size
        type: cell_data_payload(cell_count)

  cell_data_payload:
    params:
      - id: cell_count
        type: u4
    seq:
      - id: timestamps
        type: u8
        repeat: expr
        repeat-expr: cell_count
      - id: param_sizes_raw
        type: u4
        repeat: expr
        repeat-expr: cell_count
      - id: param_blobs
        type: cell_param_entry(param_sizes_raw[_index])
        repeat: expr
        repeat-expr: cell_count

  cell_param_entry:
    doc: |
      One cell-parameter blob aligned with a single cell identifier and a single
      timestamp.
    params:
      - id: blob_size
        type: u4
    seq:
      - id: blob
        size: blob_size
        type: cell_params_blob
        if: blob_size > 0 and blob_size != 4294967295

  cell_params_blob:
    doc: |
      Human-readable decomposition of the cell-parameter blob used by CFPC1.

      Observed layout:
      - 3-byte S2 prefix
      - 2-byte local S2 cell ID for the primary-only estimate
      - 1-byte raw accuracy
      - zero or more neighbor records until end-of-stream
    seq:
      - id: s2_prefix_b0
        type: u1
      - id: s2_prefix_b1
        type: u1
      - id: s2_prefix_b2
        type: u1
      - id: main_local_cell_id
        type: u2
      - id: main_accuracy_raw
        type: u1
      - id: neighbor_records
        type: neighbor_record
        repeat: eos
    instances:
      s2_prefix:
        value: (s2_prefix_b0 << 16) | (s2_prefix_b1 << 8) | s2_prefix_b2

  neighbor_record:
    doc: |
      Variable-length neighbor-conditioned estimate:
      [N][MASK][N bytes PCI/PSC][2 bytes local_cell_id][1 byte accuracy]
    seq:
      - id: count
        type: u1
      - id: add_256_mask
        type: u1
      - id: pci_psc_base_values
        type: u1
        repeat: expr
        repeat-expr: count
      - id: local_cell_id
        type: u2
      - id: accuracy_raw
        type: u1
