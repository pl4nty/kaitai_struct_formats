meta:
  id: crc16_a
  title: A variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xc6c6
  -check: 0xbf05
  -polynomial: 0x1021
  -reflect-in: true
  -reflect-out: true
doc: Computes the A variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0xc6c6, 0x0, true, true, 0x1021, array)

instances:
  value:
    value: generic.value
