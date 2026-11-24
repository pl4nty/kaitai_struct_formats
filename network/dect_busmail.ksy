# Imported from https://github.com/dzervas/dector/blob/b1482546fa3cf1b1df1d5aa7fb35cdf47292322b/structs/busmail.ksy
meta:
  id: dect_busmail
  title: DECT busmail protocol
  license: LicenseRef-All-Rights-Reserved
  imports:
    - dect_busmail_header
    - dect_busmail_mail
  endian: be

seq:
  - id: frame_char
    type: u1
    doc: Start-of-frame indicator (often 0x10)

  - id: length
    type: u2
    doc: Length of header (1 byte) + payload (mail)

  - id: header
    size: 1
    type: dect_busmail_header
    doc: The actual header is going to get parsed after the CRC calculation

  - id: mail
    size: length - 1
    type: dect_busmail_mail
    if: length - 1 > 0
    doc: The payload of the frame, parsed later

  - id: checksum
    type: u1
    doc: 8-bit checksum = (header_raw + all payload bytes) mod 256

# TODO: Check if the checksum is correct
