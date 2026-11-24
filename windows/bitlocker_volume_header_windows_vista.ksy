# Imported from https://gist.githubusercontent.com/u1735067/b864e995fc7f9919a9a6ebaf1dee4c54/raw/5b3e346d5e43e3120d34abd0316d07cd305ba213/bde_volume_header_windows_vista.ksy.yml
meta:
  id: bitlocker_volume_header_windows_vista
  title: BitLocker Windows Vista volume header
  license: LicenseRef-All-Rights-Reserved
  endian: le

doc-ref:
  - https://github.com/libyal/libbde/blob/master/libbde/bde_volume.h
  - https://github.com/libyal/libbde/blob/master/libbde/libbde_io_handle.c

types:
  bitlocker_vol_vista:
    seq:
      - id: boot_entry_point
        contents: [ 0xeb, 0x58, 0x90 ]
      - id: signature
        contents: '-FVE-FS-'
      - id: bytes_per_sector
        type: u2
      - id: sectors_per_cluster_block
        type: u1
      - id: unknown1
        size: 5
      - id: total_number_of_sectors_16bit
        type: u2
      - id: media_descriptor
        type: u1
      - id: unknown2
        size: 2
      - id: sectors_per_track
        type: u2
      - id: number_of_heads
        type: u2
      - id: number_of_hidden_sectors
        type: u4
      - id: total_number_of_sectors_32bit
        type: u4
        
        
      - id: unknown3
        size: 4
      - id: total_number_of_sectors_64bit
        type: u8
      - id: mft_cluster_block_number
        type: u8
      - id: first_metadata_cluster_block_number
        type: u8
      - id: mft_entry_size
        type: u4
      - id: index_entry_size
        type: u4
      - id: volume_serial_number
        type: u8
      - id: checksum
        type: u4
      - id: bootcode
        size: 426
      - id: sector_signature
        contents: [ 0x55, 0xAA ]
    
