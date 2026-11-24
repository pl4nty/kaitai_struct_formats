meta:
  id: crc16_t10_dif
  title: T10-DIF variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0xd0db
  -polynomial: 0x8bb7
  -reflect-in: false
  -reflect-out: false
doc: Computes the T10-DIF variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0, 0x0, false, false, 0x8bb7, array)

instances:
  value:
    value: generic.value
