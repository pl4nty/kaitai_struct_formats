meta:
  id: samsung_signature
  title: Samsung Crypto Signature for Android Firmware Images
  license: CC0-1.0
  encoding: UTF-8

doc: |
  Signature that Samsung appends to Android image files.
  Only part of the fields reversed. A phone's bootloader
  checks images signature validity during boot.

types:
  samsung_signature:
    seq:
      - id: signer_name
        size: 16
        type: strz
      - id: signer_ver
        size: 16
        type: strz
      - id: firmware_ver
        size: 32
        type: strz
        doc: android firmware version string
      - id: firmware_timestamp
        size: 16
        type: strz
      - id: phone_model
        size: 32
        type: strz
      - id: board1
        size: 16
        type: strz
      - id: board2
        size: 16
        type: strz
