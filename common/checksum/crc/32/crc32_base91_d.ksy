meta:
  id: crc32_base91_d
  title: BASE91-D variant of CRC-32
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffffffff
  -check: 0x87315576
  -polynomial: 0xa833982b
  -reflect-in: true
  -reflect-out: true
doc: Computes the BASE91-D variant of CRC-32 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(32, 0xffffffff, 0xffffffff, true, true, 0xa833982b, array)

instances:
  value:
    value: generic.value
