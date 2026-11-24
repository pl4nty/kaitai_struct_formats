meta:
  id: crc32_mef
  title: MEF variant of CRC-32
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffffffff
  -check: 0xd2c22f51
  -polynomial: 0x741b8cd7
  -reflect-in: true
  -reflect-out: true
doc: Computes the MEF variant of CRC-32 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(32, 0xffffffff, 0x0, true, true, 0x741b8cd7, array)

instances:
  value:
    value: generic.value
