# Imported from https://github.com/peterzieba/5Vpld/blob/c45f1ad54b4691360db8e6ddb63765024703e2c7/device-library/cupl-dl.ksy
meta:
  id: cupl_dl
  title: Decoder for CUPL .DL device library files.
  application:
    - CUPL.EXE
    - CSIM.EXE
    - CBLD.EXE
  file-extension: dl
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: magic
    contents: [0x31, 0xD4, 0x28, 0x00]
  - id: libname
    size: 17
    type: strz
    encoding: ASCII
  - id: lib
    size: 17
    type: strz
    encoding: ASCII
  - id: copy
    size: 161
    type: strz
    encoding: ASCII
  - id: chip
    type: chip_entry
    repeat: expr
    repeat-expr: 1000

types:
  chip_entry:
    seq:
      - id: name
        size: 17
        type: strz
        encoding: ASCII
      - id: is_entry
        #type: b1
        type: u1
        enum: tf
      - id: entry_size
        type: u4
      - id: entry_offset
        type: u4
    instances:
      chipblob:
        pos: entry_offset
        size: entry_size
        type: chip_blob
  chip_blob:
    seq:
      - id: magic
        contents: [0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0xC7, 0x00, 0x00, 0x00, 0x00]
        #size: 11
      - id: dunno0
        size: 73
      - id: num_extensions
        type: u1
      - id: dunno1
        size: 100
      - id: dunno2
        size: 75
      - id: revision
        type: u1
      - id: dunno2aa
        size: 7

      - id: pins
        type: u1
      - id: dunno2a
        size: 12
      - id: num_fuses
        type: u4
      - id: dunno3
        size: 4
      - id: pterms
        type: u2
      - id: dunno3a
        size: 94
      - id: dunno4
        size: 26
      - id: chip_extension
        type: chip_extension_type
        repeat: expr
        repeat-expr: num_extensions
  chip_extension_type:
    seq:
      - id: ext_id
        type: u1
      - id: ext_name
        size: 20
        type: strz
        encoding: ASCII


enums:
  tf:
    0: false
    1: true
