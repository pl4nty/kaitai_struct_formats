meta:
  id: crc64_microsoft
  title: Microsoft variant of CRC-64
  license: Unlicense
  imports:
    - ../crc_generic
  -initial: 0xffffffffffffffff
  -check: 0x75d4b74f024eceea
  -polynomial: 0x259c84cba6426349
  -reflect-in: true
  -reflect-out: true
doc: Computes the Microsoft variant of CRC-64 of an array.

params:
  - id: array
    type: bytes

seq:
  - id: generic
    type: crc_generic(64, 0xffffffffffffffff, 0x0, true, true, 0x259c84cba6426349, array)

instances:
  value:
    value: generic.value
