meta:
  id: crc16_gsm
  title: GSM variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0xce3c
  -polynomial: 0x1021
  -reflect-in: false
  -reflect-out: false
doc: Computes the GSM variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0, 0xffff, false, false, 0x1021, array)

instances:
  value:
    value: generic.value
