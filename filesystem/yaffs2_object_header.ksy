# Imported from https://github.com/synacktiv/yealink_tools/blob/513308d2be9beeef4298fe41743605208e16a436/yaffs.ksy
meta:
  id: yaffs2_object_header
  title: Yaffs header
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII
  endian: le
doc: |
  Yealink partial yaffs header
  (c) Synacktiv 2019

seq:
  - id: obj_type
    type: u4
    enum: obj_type
  - id: parent_obj_id
    type: u4
  - id: unused_checksum
    contents: [0xFF, 0xFF]
  - id: name
    size: 256
    type: strz
  - id: yst_mode
    type: u4
  - id: yst_uid
    type: u4
  - id: yst_gid
    type: u4
  - id: yst_atime
    type: u4
  - id: yst_mtime
    type: u4
  - id: yst_ctime
    type: u4
  - id: padding
    type: u2
  - id: file_size_low
    type: u4
  - id: equiv_id
    type: u4
  - id: alias
    size: 128

    type:
      switch-on: obj_type
      cases:
        'obj_type::symlink': strz
        _ : u1
enums:
  obj_type:
    0x00: unknown
    0x01: file
    0x02: symlink
    0x03: directory
    0x04: hardlink
    0x05: special
