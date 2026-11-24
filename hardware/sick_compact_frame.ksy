# Imported from https://github.com/SICKAG/KaitaiStructDescriptions/blob/7ea18d7afce430a3ec02b1c20ca57aa86392809a/formats/compact_frame.ksy
meta:
  id: sick_compact_frame
  title: SICK Compact format frame
  license: LicenseRef-All-Rights-Reserved
  imports:
    - sick_compact_type_1_primary_data_spherical_coordinates
    - sick_compact_type_2_imu
    - sick_compact_type_3_ambient_light
    - sick_compact_type_4_encoder
    - sick_compact_type_6_primary_data_multiscan200
    - sick_compact_type_7_imu_standard_header
  endian: le

  bit-endian: be

seq:
  - id: start_of_frame
    contents: [0x02, 0x02, 0x02, 0x02]

  - id: telegram_type
    type: u4
    doc: |
      1 = Primary Data - Spherical Coordinates
      2 = IMU
      3 = Ambient Light
      4 = Encoder
      6 = Primary Data - multiScan200
      7 = IMU (Standard Header)

  - id: payload
    type:
      switch-on: telegram_type
      cases:
        1: sick_compact_type_1_primary_data_spherical_coordinates
        2: sick_compact_type_2_imu
        3: sick_compact_type_3_ambient_light
        4: sick_compact_type_4_encoder
        6: sick_compact_type_6_primary_data_multiscan200
        7: sick_compact_type_7_imu_standard_header

  - id: checksum
    type: u4
    doc: CRC32 over start_of_frame + telegram_type + payload.
