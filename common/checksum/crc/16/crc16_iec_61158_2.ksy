meta:
  id: crc16_iec_61158_2
  title: PROFIBUS, IEC-61158-2 variant of CRC-16
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffff
  -check: 0xa819
  -polynomial: 0x1dcf
  -reflect-in: false
  -reflect-out: false
doc: Computes the PROFIBUS, IEC-61158-2 variant of CRC-16 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(16, 0xffff, 0xffff, false, false, 0x1dcf, array)

instances:
  value:
    value: generic.value
