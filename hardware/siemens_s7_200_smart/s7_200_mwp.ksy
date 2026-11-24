# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/mwp.ksy
# Licence and copyright: see _community/README.md
meta:
  id: s7_200_mwp
  title: Micro/WIN project file
  file-extension: mwp
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
            - '"R04.03"'   # what is this
              # this is found on the test files we personally
              # generated and edited on Micro/WIN v4.0 SP9

      - type: smart_types::nulls(2)
        if: file_version == "R04.00"
            or file_version == "R04.03"

      - type: u2
        if: file_version == "R03.20"

      - type: u4
        valid: 0
        if: file_version == "R04.00"
            or file_version == "R04.03"

      - id: library_marker
        type: u4
        # valid: 1
        # 1 = library
        # 0 = project

      - id: maybe_checksum
        size: 16
        if: file_version == "R04.00"
            or file_version == "R04.03"

      - id: encoded_password_v4
        size: 16
        if: file_version == "R04.00"
            or file_version == "R04.03"
        # always null for mwl files (?)

      - id: encoded_password_v3
        size: 8
        if: file_version == "R03.20"

      - id: uncompressed_len
        type: u4

  body:
    seq:
      - id: body
        size-eos: True
