# Imported from https://github.com/SICKAG/KaitaiStructDescriptions/blob/7ea18d7afce430a3ec02b1c20ca57aa86392809a/formats/type_4_encoder.ksy
meta:
  id: sick_compact_type_4_encoder
  title: SICK Compact type 4 encoder data
  license: LicenseRef-All-Rights-Reserved
  imports:
    - sick_compact_header
  endian: le

  bit-endian: be

doc: |
  Compact Format Type 4 - Encoder.
  Sensor: picoScan150.

seq:
  - id: header
    type: sick_compact_header

  - id: frame_number
    type: u8
    doc: Corresponding primary data frame number.

  - id: tick_count
    type: u4

  - id: tick_count_at_reference_signal_1
    type: u4
    doc: Tick count when reference signal 1 signal detected.

  - id: tick_count_at_reference_signal_2
    type: u4
    doc: Tick count when reference signal 2 signal detected.

  - id: speed
    type: f4
    doc: Speed [units/s] per configured conversion rate.

  - id: tick_count_timestamp
    type: u8
    doc: Timestamp of last tick counter change [us, Unix].

  - id: timestamp_of_reference_signal_1
    type: u8
    doc: Timestamp of last reference signal 1 signal change [us, Unix].

  - id: timestamp_of_reference_signal_2
    type: u8
    doc: Timestamp of last reference signal 2 signal change [us, Unix].
