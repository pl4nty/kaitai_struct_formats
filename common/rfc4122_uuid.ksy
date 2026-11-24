meta:
  id: rfc4122_uuid
  title: RFC 4122 / RFC 9562 UUID (binary, network byte order)
  xref:
    rfc:
      - 4122
      - 9562
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  A universally unique identifier (UUID, also known as GUID) in its
  16-byte binary form, with all fields in network (big-endian) byte order,
  as defined by RFC 4122 (obsoleted by RFC 9562). The textual form
  `xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx` is the hex dump of these 16 bytes.

  The `variant` is given by the top bits of `clock_seq_hi_variant`; for the
  RFC 4122 variant, `version` (the top 4 bits of `time_hi_and_version`)
  identifies how the UUID was generated: 1 = time-based (Gregorian
  timestamp + node), 2 = DCE security, 3 = name-based MD5, 4 = random,
  5 = name-based SHA-1, 6 = reordered time-based, 7 = Unix-epoch
  time-based, 8 = custom.

  Note that Microsoft GUID structures (and many file formats derived from
  them) store `time_low`, `time_mid` and `time_hi_and_version` in
  little-endian order instead; this type does not cover that layout.
doc-ref:
  - https://www.rfc-editor.org/rfc/rfc9562.txt
  - https://www.rfc-editor.org/rfc/rfc4122.txt
  - https://github.com/python/cpython/blob/main/Lib/uuid.py
seq:
  - id: time_low
    type: u4
    doc: Bytes 0-3. Low 32 bits of the timestamp for versions 1 and 2.
  - id: time_mid
    type: u2
    doc: Bytes 4-5.
  - id: time_hi_and_version
    type: u2
    doc: Bytes 6-7. Top 4 bits are the version.
  - id: clock_seq_hi_variant
    type: u1
    doc: Byte 8. Top 1-3 bits are the variant.
  - id: clock_seq_low
    type: u1
    doc: Byte 9.
  - id: node
    size: 6
    doc: Bytes 10-15. For version 1, usually an IEEE 802 MAC address.
instances:
  variant:
    value: |
      (clock_seq_hi_variant & 0x80) == 0 ? variants::reserved_ncs :
      (clock_seq_hi_variant & 0x40) == 0 ? variants::rfc4122 :
      (clock_seq_hi_variant & 0x20) == 0 ? variants::reserved_microsoft :
      variants::reserved_future
  version:
    value: time_hi_and_version >> 12
    doc: Version number; only meaningful for the RFC 4122 variant.
  clock_seq:
    value: ((clock_seq_hi_variant & 0x3f) << 8) | clock_seq_low
    doc: 14-bit clock sequence (RFC 4122 variant, versions 1, 2 and 6).
  timestamp_v1:
    value: ((time_hi_and_version & 0x0fff).as<u8> << 48) | (time_mid.as<u8> << 32) | time_low
    doc: |
      60-bit timestamp of version 1 UUIDs: 100-nanosecond intervals since
      1582-10-15 00:00:00 UTC (subtract 0x01B21DD213814000 to get 100 ns
      units since the Unix epoch).
  timestamp_v6:
    value: (time_low.as<u8> << 28) | (time_mid.as<u8> << 12) | (time_hi_and_version & 0x0fff)
    doc: 60-bit Gregorian timestamp of version 6 UUIDs (same units as `timestamp_v1`).
  unix_ts_ms_v7:
    value: (time_low.as<u8> << 16) | time_mid
    doc: 48-bit Unix timestamp in milliseconds of version 7 UUIDs.
enums:
  variants:
    0: reserved_ncs
    1: rfc4122
    2: reserved_microsoft
    3: reserved_future
