meta:
  id: crc16_aug_ccitt
  title: AUG-CCITT variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x1d0f
  -check: 0xe5cc
  -polynomial: 0x1021
  -reflect-in: false
  -reflect-out: false
doc: Computes the AUG-CCITT variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0x1d0f, 0x0, false, false, 0x1021, array)

instances:
  value:
    value: generic.value
