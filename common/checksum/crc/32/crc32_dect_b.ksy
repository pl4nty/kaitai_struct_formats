meta:
  id: crc32_dect_b
  title: BZIP2 variant of CRC-32
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffffffff
  -check: 0xfc891918
  -polynomial: 0x4c11db7
  -reflect-in: false
  -reflect-out: false
doc: Computes the BZIP2 variant of CRC-32 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(32, 0xffffffff, 0xffffffff, false, false, 0x4c11db7, array)

instances:
  value:
    value: generic.value
