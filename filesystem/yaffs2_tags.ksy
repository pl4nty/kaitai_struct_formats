# Imported from https://github.com/synacktiv/yealink_tools/blob/513308d2be9beeef4298fe41743605208e16a436/yaffs_tags.ksy
meta:
  id: yaffs2_tags
  title: Yaffs tag
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII
  endian: le
doc: |
  Yealink custom yaffs2 tag
  (c) Synacktiv 2019
seq:
  - id: padding2
    size: 1
  - id: unknown 
    type: u4
  - id: unknown_4
    size: 3
  - id: obj_id_lsb1
    type: u1
  - id: ecc2
    size: 7
  - id: obj_id_lsb2
    type: u1
  - id: obj_id_msb
    type: u2
  - id: seq_id
    type: u4
  - id: nbytes
    type: u2
  - id: unknown_and_ecc
    size: 5
  - id: unknown_2
    size: 4
  - id: crypto_magic
    contents: [0x15, 0x08, 0x86, 0x19]
  - id: unknown_3
    type: u2
  - id: unknown_and_ecc_2
    size: 7
instances:
  obj_id:
    value: obj_id_lsb1 | obj_id_lsb2 << 8 | obj_id_msb << 16
