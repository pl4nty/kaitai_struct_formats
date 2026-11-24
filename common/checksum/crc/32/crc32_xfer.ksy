meta:
  id: crc32_xfer
  title: XFER variant of CRC-32
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0xbd0be338
  -polynomial: 0xaf
  -reflect-in: false
  -reflect-out: false
doc: Computes the XFER variant of CRC-32 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(32, 0, 0x0, false, false, 0xaf, array)

instances:
  value:
    value: generic.value
