# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/mwl.ksy
# Licence and copyright: see _community/README.md
meta:
  id: s7_200_mwl
  title: Micro/WIN compiled library file
  file-extension: mwl
  license: MIT
  ks-version: 0.11
  imports:
    - smart_types
  endian: le
  bit-endian: le

seq:
  - id: header
    type: header
  - id: body
    size-eos: true

types:

  header:
    seq:
      - id: signature
        size: 4
        type: str
        encoding: ISO-8859-1
        valid: '"GJK\0"'

      - id: file_version
        size: 6
        type: str
        encoding: ISO-8859-1
        valid:
          any-of:
            - '"R03.20"'
            - '"R04.00"'

      - type: smart_types::nulls(2)
        if: file_version == "R04.00"

      - type: u4
        valid:
          any-of: [0, 1]
        if: file_version == "R04.00"

      - id: library_marker
        type: u4
        valid: 1
        # 1 = library
        # 0 = project

      - id: maybe_checksum
        size: 16

      - id: encoded_password_v4
        size: 16
        if: file_version == "R04.00"
        # always null for mwl files (?)

      - id: encoded_password_v3
        size: 10
        if: file_version == "R03.20"
      - type: smart_types::nulls(4)
        if: file_version == "R03.20"

      - id: uncompressed_len
        type: u4

  body:
    seq:
      - id: body
        size-eos: True
