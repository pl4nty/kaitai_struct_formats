# Imported from https://gist.githubusercontent.com/u1735067/b864e995fc7f9919a9a6ebaf1dee4c54/raw/5b3e346d5e43e3120d34abd0316d07cd305ba213/bde_metadatas.ksy.yml
meta:
  id: bitlocker_metadata
  title: BitLocker metadata
  license: LicenseRef-All-Rights-Reserved
  endian: le

doc-ref:
  - https://github.com/libyal/libbde/blob/master/libbde/bde_metadata.h
  - https://github.com/libyal/libbde/blob/master/libbde/libbde_definitions.h.in

# This will be find at first_metadata_offset from bde_volume_header
seq:
  - id: metadata
    type: bde_metadata
    
types:
  bde_metadata:
    seq:
      - id: bde_metadata_block_header_common
        type: bde_metadata_block_header_common
      - id: bde_metadata_block_header_specific
        type: 
          switch-on: bde_metadata_block_header_common.version
          cases:
            1: bde_metadata_block_header_v1
            2: bde_metadata_block_header_v2
      - id: bde_metadata_header
        type: bde_metadata_header_v1
      - id: bde_metadata_entries
        size: bde_metadata_header.metadata_size - bde_metadata_header.metadata_header_size
        type: bde_metadata_entries_list
  
  bde_metadata_block_header_common:
    seq:
      - id: signature
        contents: '-FVE-FS-'
      - id: size
        type: u2
      - id: version
        type: u2
  bde_metadata_block_header_v1:
    seq: 
      - id: unknown1
        size: 2
      - id: unknown2
        size: 2
      - id: unknown3
        size: 16
      - id: first_metadata_offset
        type: u8
      - id: second_metadata_offset
        type: u8
      - id: third_metadata_offset
        type: u8
      - id: mft_mirror_cluster_block
        type: u8
  bde_metadata_block_header_v2:
    seq:
      - id: unknown1
        size: 2
      - id: unknown2
        size: 2
      - id: encrypted_volume_size
        type: u8
      - id: unknown3
        size: 4
      - id: number_of_volume_header_sectors
        type: u4
      - id: first_metadata_offset
        type: u8
      - id: second_metadata_offset
        type: u8
      - id: third_metadata_offset
        type: u8
      - id: volume_header_offset
        type: u8
  bde_metadata_header_v1:
    seq: 
      - id: metadata_size
        type: u4
      - id: version
        type: u4
      - id: metadata_header_size
        type: u4
      - id: metadata_size_copy
        type: u4
      - id: volume_identifier
        size: 16
      - id: next_nonce_counter
        type: u4
      - id: encryption_method
        type: u2
        enum: encryption_method
      - id: encryption_method_copy
        type: u2
      - id: creation_time
        type: u8
        doc: Contains a filetime
  bde_metadata_entries_list:
    seq:
      - id: list
        type: bde_metadata_entry
        repeat: eos
  bde_metadata_entry:
    seq:
      - id: entry_header
        type: bde_metadata_entry_header_v1
      - id: entry_content
        size: entry_header.size - 8 # Remove the size of the entry header
        type:
          switch-on: entry_header.value_type
          cases:
            value_type::key: bde_metadata_entry_key
            value_type::unicode_string: bde_metadata_entry_unicode_string
            value_type::stretch_key: bde_metadata_entry_stretch_key
            value_type::aes_ccm_encrypted_key: bde_metadata_entry_aes_ccm_encrypted_key
            value_type::volume_master_key: bde_metadata_entry_volume_master_key
            value_type::external_key: bde_metadata_entry_external_key
            value_type::offset_and_size: bde_metadata_entry_offset_and_size
  bde_metadata_entry_header_v1:
    seq:
      - id: size
        type: u2
      - id: type
        type: u2
        enum: entry_type
      - id: value_type
        type: u2
        enum: value_type
      - id: version
        type: u2
  bde_metadata_entry_key:
    seq:
      - id: encryption_method
        type: u4
      - id: key
        size-eos: true
  bde_metadata_entry_unicode_string:
    seq:
      - id: text
        size-eos: true
        type: str
        encoding: UTF-16LE
  bde_metadata_entry_stretch_key:
    seq:
      - id: encryption_method
        type: u4
        enum: encryption_method
      - id: salt
        size: 16
      - id: stretch_key
        size-eos: true
  bde_metadata_entry_aes_ccm_encrypted_key:
    seq:
      - id: nonce_time
        type: u8
        doc: Contains a filetime
      - id: nonce_counter
        type: u4
      - id: aes_ccm_encrypted_key
        type: aes_ccm_encrypted_key
  aes_ccm_encrypted_key:
    seq:
      - id: aes_ctr_encrypted_cbc_mac
        size: 16
      - id: aes_ctr_encrypted_key
        size-eos: true
  bde_metadata_entry_volume_master_key:
    seq:
      - id: identifier
        size: 16
        doc: Contains a GUID
      - id: modification_time
        type: u8
        doc: Contains a filetime
      - id: unknown1
        size: 2
      - id: protection_type
        type: u2
        enum: protection_type
      - id: volume_master_key
        type: bde_metadata_entry_generic_properties
  bde_metadata_entry_external_key:
    seq:
      - id: identifier
        size: 16
        doc: Contains a GUID
      - id: modification_time
        type: u8
        doc: Contains a filetime
      - id: external_key
        type: bde_metadata_entry_generic_properties
  bde_metadata_entry_offset_and_size:
    seq:
      - id: offset
        type: u8
      - id: size
        type: u8
      - id: unknown1 # Doesn't seems to be other copies
        size-eos: true
  bde_metadata_entry_generic_properties: # Like bde_metadata_entries_list
    seq:
      - id: properties
        type: bde_metadata_entry
        repeat: eos

enums:
  encryption_method:
    0x8000: aes_128_cbc_diffuser
    0x8001: aes_256_cbc_diffuser
    0x8002: aes_128_cbc
    0x8003: aes_256_cbc
    0x8004: aes_128_xts
    0x8005: aes_256_xts
  protection_type:
    0x0000: clear_text
    0x0100: tpm
    0x0200: startup_key
    0x0800: recovery_password
    0x2000: password
  entry_type:
    0x0000: property
    0x0002: volume_master_key
    0x0003: full_volume_encryption_key
    0x0004: validation
    0x0006: startup_key
    0x0007: description
    0x000f: volume_header_block
  value_type:
    0x0000: erased
    0x0001: key
    0x0002: unicode_string
    0x0003: stretch_key
    0x0004: use_key
    0x0005: aes_ccm_encrypted_key
    0x0006: tpm_encoded_key
    0x0007: validation
    0x0008: volume_master_key
    0x0009: external_key
    0x000A: update
    0x000B: error
    0x000F: offset_and_size
