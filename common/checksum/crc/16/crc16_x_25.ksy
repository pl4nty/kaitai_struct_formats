meta:
  id: crc16_x_25
  title: X-25 variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffff
  -check: 0x906e
  -polynomial: 0x1021
  -reflect-in: true
  -reflect-out: true
doc: Computes the X-25 variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0xffff, 0xffff, true, true, 0x1021, array)

instances:
  value:
    value: generic.value
