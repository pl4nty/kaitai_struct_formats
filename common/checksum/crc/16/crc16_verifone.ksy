meta:
  id: crc16_verifone
  title: BUYPASS variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0xfee8
  -polynomial: 0x8005
  -reflect-in: false
  -reflect-out: false
doc: Computes the BUYPASS variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0, 0x0, false, false, 0x8005, array)

instances:
  value:
    value: generic.value
