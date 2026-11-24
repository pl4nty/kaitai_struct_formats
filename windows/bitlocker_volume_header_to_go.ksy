# Imported from https://gist.githubusercontent.com/u1735067/b864e995fc7f9919a9a6ebaf1dee4c54/raw/5b3e346d5e43e3120d34abd0316d07cd305ba213/bde_volume_header_to_go.ksy.yml
meta:
  id: bitlocker_volume_header_to_go
  title: BitLocker To Go volume header
  license: LicenseRef-All-Rights-Reserved
  endian: le

doc-ref:
  - https://github.com/libyal/libbde/blob/master/libbde/bde_volume.h
  - https://github.com/libyal/libbde/blob/master/libbde/libbde_io_handle.c

types:
  bitlocker_vol_togo:
    seq:
      - id: boot_entry_point
        size: 3
      - id: signature
        contents: 'MSWIN4.1'
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
        size: 31
      - id: volume_serial_number
        type: u4
      - id: volume_label
        size: 11
        type: str
        encoding: ASCII
      - id: file_system_signature
        size: 8
      - id: bootcode
        size: 334
      - id: identifier
        size: 16
        doc: Contains a GUID
      - id: first_metadata_offset
        type: u8
      - id: second_metadata_offset
        type: u8
      - id: third_metadata_offset
        type: u8
      - id: unknown4
        size: 46
      - id: sector_signature
        contents: [ 0x55, 0xAA ]
