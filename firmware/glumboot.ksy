# Imported from https://github.com/thewisenerd/glumboot-utils/blob/b562aff8e43b6f2c7efed7fb005881cdbc98d34c/glumboot.ksy
meta:
  id: glumboot
  title: glumboot boot image
  file-extension: img
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents: ['glumboot']
  - id: reserved__1
    type: u1
    repeat: expr
    repeat-expr: 4
  - id: partition_count
    type: u4
  - id: crc32
    type: u4
  - id: reserved__2
    type: u1
    repeat: expr
    repeat-expr: 12
  - id: partitions
    type: glumboot_partition_type
    repeat: expr
    repeat-expr: partition_count
types:
  glumboot_partition_type:
    seq:
      - id: name
        size: 20
        type: strz
        encoding: ASCII
      - id: offset
        type: u4
      - id: size
        type: u4
      - id: flags
        type: u4
