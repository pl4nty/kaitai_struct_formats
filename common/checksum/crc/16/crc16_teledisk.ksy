meta:
  id: crc16_teledisk
  title: TELEDISK variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0xfb3
  -polynomial: 0xa097
  -reflect_in: false
  -reflect_out: false
doc: Computes TELEDISK variant of 16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0, 0x0, false, false, 0xa097, array)

instances:
  value:
    value: generic.value
