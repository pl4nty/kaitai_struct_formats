meta:
  id: crc32_castagnoli
  title: Castagnoli variant of CRC-32
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffffffff
  -check: 0xe3069283
  -polynomial: 0x1edc6f41
  -reflect-in: true
  -reflect-out: true
doc: Computes the Castagnoli variant of CRC-32 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(32, 0xffffffff, 0xffffffff, true, true, 0x1edc6f41, array)

instances:
  value:
    value: generic.value
