meta:
  id: crc32_autosar
  title: AUTOSAR variant of CRC-32
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffffffff
  -check: 0x1697d06a
  -polynomial: 0xf4acfb13
  -reflect-in: true
  -reflect-out: true
doc: Computes the AUTOSAR variant of CRC-32 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(32, 0xffffffff, 0xffffffff, true, true, 0xf4acfb13, array)

instances:
  value:
    value: generic.value
