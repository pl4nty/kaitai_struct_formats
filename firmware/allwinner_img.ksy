# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/allwinner_img/allwinner_img.ksy
# Licence and copyright: see _community/README.md
meta:
  id: allwinner_img
  title: Allwinner image format
  file-extension: img
  tags:
    - android
    - archive
  license: CC0-1.0
  endian: le
doc: |
  Format of boot files found on certain Android devices based on Allwinner
  chipsets.

doc-ref: https://github.com/Ithamar/awutils/blob/5d6284e/imagewty.h
seq:
  - id: img_header
    size: 1024
    type: header
  - id: file_headers
    type: file_header
    repeat: expr
    repeat-expr: img_header.num_files
types:
  header:
    seq:
      - id: magic
        contents: "IMAGEWTY"
      - id: header_version
        type: u4
      - id: len_header
        -orig-id: header_size
        type: u4
      - id: ram_base
        type: u4
      - id: format_version
        -orig-id: version
        type: u4
        valid: 0x100234
      - id: len_image
        -orig-id: image_size
        type: u4
      - id: len_image_header
        -orig-id: image_header_size
        type: u4
      - id: unknown
        type: u4
        if: header_version == 0x300
      - id: usb_pid
        -orig-id: pid
        type: u4
      - id: usb_vid
        -orig-id: vid
        type: u4
      - id: hardware_id
        type: u4
      - id: firmware_id
        type: u4
      - id: val1
        type: u4
        valid: 1
      - id: val1024_1
        type: u4
        valid: 1024
      - id: num_files
        type: u4
      - id: val1024_2
        type: u4
        valid: 1024
      - id: val0_1
        type: u4
        valid: 0
      - id: val0_2
        type: u4
        valid: 0
      - id: val0_3
        type: u4
        valid: 0
      - id: val0_4
        type: u4
        valid: 0
  file_header:
    seq:
      - id: common
        type: file_header_common
      - id: file_header_data
        size: common.len_header_total - common._sizeof
        type:
          switch-on: _root.img_header.header_version
          cases:
            0x100: file_header_v1
            0x300: file_header_v3
  file_header_common:
    seq:
      - id: len_filename
        -orig-id: filename_len
        type: u4
      - id: len_header_total
        -orig-id: total_header_size
        type: u4
      - id: maintype
        size: 8
        type: str
        encoding: ASCII
      - id: subtype
        size: 16
        type: str
        encoding: ASCII
  file_header_v1:
    seq:
      - id: unknown_1
        type: u4
      - id: stored_length
        type: u4
      - id: original_length
        type: u4
      - id: offset
        type: u4
      - id: unknown_2
        type: u4
      - id: name
        -orig-id: filename
        size: 256
        type: strz
        encoding: ASCII
  file_header_v3:
    seq:
      - id: unknown_0
        type: u4
        valid: 0
      - id: name
        -orig-id: filename
        size: 256
        type: strz
        encoding: ASCII
      - id: stored_length
        type: u4
      - id: pad1
        size: 4
      - id: original_length
        type: u4
      - id: pad2
        size: 4
      - id: offset
        type: u4
