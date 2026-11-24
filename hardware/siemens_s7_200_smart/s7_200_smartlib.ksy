# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/smartlib.ksy
# Licence and copyright: see _community/README.md
meta:
  id: s7_200_smartlib
  title: SMART compiled library file
  file-extension: smartlib
  license: MIT
  ks-version: 0.11
  imports:
    - smart_types
  endian: le
  bit-endian: le

# TODO: refactor this part, maybe take out header and body and put them into another ksy file
#       some smartlib files have mwl signature "GJK\0" + "R04.00"

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
        valid:
          any-of:
            - '"DEM\0"'
            - '"SH3\0"'
      - id: file_version
        size: 12
        type: str
        encoding: ISO-8859-1
        valid:
          any-of:
            - '"R01.00.00.00"'
            - '"R02.04.00.00"'

      - type: smart_types::nulls(6)
      - id: library_marker
        type: u4
        valid: 1
        # 1 = library
        # 0 = project
      - id: maybe_checksum
        size: 16

      # salt and hash always (?) null on library files
      - id: salt
        size: 2
      - id: password_hash
        type:
          switch-on: file_version
          cases:
            '"R01.00.00.00"': smart_types::sha1
            '"R02.04.00.00"': smart_types::sha512

      - id: uncompressed_len
        type: u4

  body:
    seq:
      - id: body
        size-eos: True
