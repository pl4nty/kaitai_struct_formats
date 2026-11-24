meta:
  id: crc16_chakravarty
  title: Chakravarty variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffff
  -check: 0x78c4
  -polynomial: 0x2f15
  -reflect-in: true
  -reflect-out: true
doc: Computes the Chakravarty variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0xffff, 0xffff, true, true, 0x2f15, array)

instances:
  value:
    value: generic.value
