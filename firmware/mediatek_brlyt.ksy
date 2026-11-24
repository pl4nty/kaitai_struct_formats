# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/mtk_brlyt/mtk_brlyt.ksy
# Licence and copyright: see _community/README.md
meta:
  id: mediatek_brlyt
  title: MediaTek BootROM layout header
  license: GPL-2.0-or-later
  encoding: UTF-8
  endian: le
doc-ref:
  - https://source.denx.de/u-boot/u-boot/-/blob/cadb1a858d071e/tools/mtk_image.h
  - https://source.denx.de/u-boot/u-boot/-/blob/cadb1a858d071e/tools/mtk_image.c
seq:
  - id: name
    contents: ["BRLYT", 0, 0, 0]
  - id: version
    type: u4
  - id: len_header
    type: u4
  - id: len_total
    type: u4
  - id: magic
    contents: [0x42, 0x42, 0x42, 0x42]
  - id: image_type
    type: u4
    enum: img_type
  - id: len_header_2
    type: u4
    valid: len_header
  - id: len_total_2
    type: u4
    valid: len_total
  - id: unused
    size: 4
enums:
  img_type:
    0: invalid
    0x10002: nand
    0x10005: emmc
    0x10007: nor
    0x10008: sdmmc
    0x10009: snand
