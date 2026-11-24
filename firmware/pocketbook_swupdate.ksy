# Imported from https://github.com/Synacktiv-contrib/stuffz/blob/3b235897e00724f4033c2396ff5c1d8580e161f8/pocketbook_update.ksy
meta:
  id: pocketbook_swupdate
  title: PocketBook update format
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII
  endian: le

doc: |
  Pocket book update format
  A header of 0x400 bytes containing a partition table,
  and then an array of partitions
  (c) Synacktiv 2018

seq:
  - id: header
    size: 0x400
    type: header
  - id: sections
    type: section
    repeat: expr
    repeat-expr: 12

types:
  header:
    seq:
      - id: magic
        contents: 'PocketBookUpdate'
      - id: model
        size: 20
        type: strz
      - id: revision
        size: 12
        type: strz
      - id: md5_sum
        size: 16
      - id: signature
        size: 128
      - id: unknown_buffer
        size: 64
      - id: fw_partitions
        type: part_header
        repeat: until
        repeat-until: _.part_type.to_i==0x00
  part_header:
    seq:
      - id: part_type
        type: u4
        enum: part_type_enum
      - id: unused
        type: u4
      - id: offset
        type: u4
      - id: size
        type: u4
  section:
    seq:
      - id: data
        size: 0x1000

enums:
  part_type_enum:
    0x00: empty
    0x40: elf_megadog_img
    0x42: bmp_image
    0x54: dragon_tar
    0x61: a_img
    0x63: updatefs_cramfs
    0x65: ebrmain_img
    0x6B: kernel_img
    0x6E: test_null
    0x72: rootfs_img
    0x73: swupdate_tar_gz
    0x75: uboot_loader
