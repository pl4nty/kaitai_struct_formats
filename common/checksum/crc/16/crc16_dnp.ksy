meta:
  id: crc16_dnp
  title: DNP variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0xea82
  -polynomial: 0x3d65
  -reflect-in: true
  -reflect-out: true
doc: Computes the DNP variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0, 0xffff, true, true, 0x3d65, array)

instances:
  value:
    value: generic.value
