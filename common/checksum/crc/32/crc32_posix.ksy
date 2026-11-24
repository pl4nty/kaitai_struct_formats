meta:
  id: crc32_posix
  title: POSIX variant of CRC-32
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0x0
  -check: 0x765e7680
  -polynomial: 0x4c11db7
  -reflect-in: false
  -reflect-out: false
doc: Computes the POSIX variant of CRC-32 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(32, 0, 0xffffffff, false, false, 0x4c11db7, array)

instances:
  value:
    value: generic.value
