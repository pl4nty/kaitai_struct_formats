meta:
  id: crc16_lj1200
  title: LJ1200 variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0xbdf4
  -polynomial: 0x6f63
  -reflect-in: false
  -reflect-out: false
doc: Computes the LJ1200 variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0, 0x0, false, false, 0x6f63, array)

instances:
  value:
    value: generic.value
