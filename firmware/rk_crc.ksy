# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/rk_crc/rk_crc.ksy
meta:
  id: rk_crc
  title: Rockchip CRC wrapper
  license: BSD-2-Clause
  encoding: UTF-8
  endian: le
doc-ref:
  - https://github.com/neo-technologies/rkflashtool/blob/master/rkcrc.c
seq:
  - id: magic
    contents: "KRNL"
  - id: len_data
    type: u4
  - id: data
    size: len_data
  - id: crc
    type: u4
