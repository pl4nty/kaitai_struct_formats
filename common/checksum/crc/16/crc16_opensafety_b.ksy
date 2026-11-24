meta:
  id: crc16_opensafety_b
  title: OPENSAFETY-B variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0x20fe
  -polynomial: 0x755b
  -reflect-in: false
  -reflect-out: false
doc: Computes the OPENSAFETY-B variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0, 0x0, false, false, 0x755b, array)

instances:
  value:
    value: generic.value
