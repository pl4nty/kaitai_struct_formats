# Imported from https://github.com/SICKAG/KaitaiStructDescriptions/blob/7ea18d7afce430a3ec02b1c20ca57aa86392809a/formats/compact_header.ksy
meta:
  id: sick_compact_header
  title: SICK Compact format header
  license: LicenseRef-All-Rights-Reserved
  endian: le

doc: Compact header shared by telegram types 4, 6, and 7.

seq:
  - id: telegram_counter
    type: u8
    doc: Counts telegrams since power-up, starts at 1.

  - id: transmit_timestamp
    type: u8
    doc: Unix timestamp [us] at transmit time.

  - id: telegram_version
    type: u4
    doc: Compact telegram format version.

  - id: payload_length
    type: u4
    doc: |
      For type 4 telegram_version 1, sender_id is counted in payload_length. From
      version 2 onwards it is not.

  - id: sender_id
    type: u4
    doc: Device serial number.
