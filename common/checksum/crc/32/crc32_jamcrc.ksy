meta:
  id: crc32_jamcrc
  title: JAMCRC variant of CRC-32
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffffffff
  -check: 0x340bc6d9
  -polynomial: 0x4c11db7
  -reflect-in: true
  -reflect-out: true
doc: Computes the JAMCRC variant of CRC-32 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(32, 0xffffffff, 0x0, true, true, 0x4c11db7, array)

instances:
  value:
    value: generic.value
