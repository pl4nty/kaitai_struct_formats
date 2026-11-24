# Imported from https://github.com/wpyoga/s7-200-smart-project-file/blob/6803dc0fd0240472457eae4245fd69e37b6a549f/kaitai/smartv3.ksy
meta:
  id: s7_200_smartv3
  title: SMART V3 project file
  file-extension: smartV3
  license: MIT
  imports:
    - smart_types
  endian: le


seq:
  - id: header
    type: header
  - id: zip_encrypted
    type: encrypted_body


types:
  header:
    seq:
      - id: null_signature
        type: u4
        valid: 0
      - id: file_version
        size: 12
        type: str
        encoding: ISO-8859-1
        valid:
          any-of: ['"R03.00.00.00"', '"R03.01.00.00"']
      - type: smart_types::nulls(2)
      - id: view_mode  # maybe network_type, or plc_lang, or something else is better?
        type: u1
        enum: view_mode
      - type: smart_types::nulls(102)
      - id: project_protection_flags
        type: u1
        valid:
          any-of: [0x02, 0x01]
      - type: smart_types::nulls(134)
  encrypted_body:
    seq:
      - id: body
        size-eos: True


enums:
  view_mode:
    0: lad
    1: stl
    2: fbd
