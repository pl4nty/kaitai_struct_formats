meta:
  id: samsung_android_pit
  title: Samsung Partition Information Table
  file-extension: pit
  license: CC0-1.0
  encoding: UTF-8
  endian: le
  #imports:
  #  - /common/samsung_signature

doc: |
  Reversed format of partition information table used in
  samsung decices.

doc-ref:
  - https://gitlab.com/BenjaminDobell/Heimdall/-/tree/master/libpit/source  # most of the fields
  - https://www.droidviews.com/need-know-samsung-pit-files/
  - https://github.com/atdog/pitparser/blob/master/pitparser.py  # `signature` is documented there
  - https://www.droidviews.com/how-to-extract-pit-file-from-samsung-galaxy-devices/  # this page also contains links to the files, to download them from Google Drive you need to construct the URI https://docs.google.com/uc?export=download&id=<file id (a string in the URI looking random, but it is not)>
  - https://source.android.com/devices/bootloader/partitions-images

seq:
  - id: magic
    type: u4
    valid: 0x12_34_98_76
  - id: num_entries
    -orig-id: entryCount
    type: u4
  - id: port
    size: 4
    type: str
  - id: format
    size: 4
    type: str
  - id: chip
    size: 8
    type: str
  - id: unknown4
    type: u4
  - id: partitions
    type: partition
    repeat: expr
    repeat-expr: num_entries
  - id: signature
    #type: samsung_signature
    size-eos: true

types:
  attributes:
    seq:
      - id: unkn0
        type: b5
      - id: bml
        -orig-id: kAttributeBML
        type: b1
      - id: stl
        -orig-id: kAttributeSTL
        type: b1
      - id: write
        -orig-id: kAttributeWrite
        type: b1
      - id: unkn1
        size: 3

  update_attributes:
    seq:
      - id: unkn0
        type: b6
      - id: secure
        -orig-id: kUpdateAttributeSecure
        type: b1
      - id: fota
        -orig-id: kUpdateAttributeFota
        type: b1
      - id: unkn1
        size: 3

  partition:
    seq:
      - id: binary_type
        type: u4
        enum: binary_type
      - id: device_type
        type: u4
        enum: device_type
      - id: identifier
        type: u4
      - id: attributes
        type: attributes
      - id: update_attributes
        type: update_attributes
      - id: len_or_ofs_block
        type: u4
        doc: partition len or partition offset from a disk beginning
      - id: num_blocks
        type: u4
        doc: partition size in blocks
      - id: ofs_file
        type: u4
        doc: obsolete
      - id: len_file
        type: u4
        doc: obsolete
      - id: partition_name
        size: 32
        type: strz
      - id: flash_filename
        size: 32
        type: strz
      - id: fota_filename
        size: 32
        type: strz

    enums:
      binary_type:
        0:
          id: cpu
          -orig-id: kBinaryTypeApplicationProcessor
        1:
          id: baseband
          -orig-id: kBinaryTypeCommunicationProcessor
      device_type:
        0:
          id: one_nand
          -orig-id: kDeviceTypeOneNand
        1:
          id: file_fat
          -orig-id: kDeviceTypeFile
        2:
          id: mmc
          -orig-id: kDeviceTypeMMC
        3:
          id: all
          -orig-id: kDeviceTypeAlls
