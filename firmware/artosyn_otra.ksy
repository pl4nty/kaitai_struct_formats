# Imported from https://github.com/fpv-wtf/ar-firmware-tools/blob/74a9c3573388660c2600c0d2ecc4045ce0698278/otra.ksy
# Licence and copyright: see _community/README.md
meta:
  id: artosyn_otra
  file-extension: img
  license: MIT
  endian: le
seq:
  - id: header
    type: header
  - id: unknown2
    size: 224
    if: header.header_version > 3
  - id: header_ext
    type: header_ext
    if: header.header_version > 3
  - id: rom
    size: header.rom_size
  - id: loader
    size: header.loader_size
  - id: env
    size: header.env_size
  - id: part_info0
    type: part_info
    repeat: expr
    repeat-expr: header.partitions0
    if: header.header_version > 1
  - id: part_info1
    type: part_info
    repeat: expr
    repeat-expr: header.partitions1
    if: header.header_version > 1
  - id: segment_info0
    type: segment_info
    repeat: expr
    repeat-expr: header.segments0
    if: header.header_version > 1
  - id: segment_info1
    type: segment_info
    repeat: expr
    repeat-expr: header.segments1
    if: header.header_version > 1
instances:
  segments0:
    type: file_body(segment_info0[_index].img_offset, segment_info0[_index].compressed_size)
    repeat: expr
    repeat-expr: header.segments0
    if: header.header_version > 1
  segments1:
    type: file_body(segment_info1[_index].img_offset, segment_info1[_index].compressed_size)
    repeat: expr
    repeat-expr: header.segments1
    if: header.header_version > 1
  #version:
  #  type: file_body(segment_info0[header.segments0-1].img_offset+segment_info0[header.segments0-1].compressed_size, 100)
types:
  header:
    seq:
      - id: magic
        contents: "OTRA"
      #bytes
      - id: hash_size
        type: u2
      #bits
      - id: sig_size
        type: u2
      - id: img_size
        type: u8
      - id: rom_size
        type: u4
      - id: loader_size
        type: u4
      - id: env_size
        type: u4
      - id: version_size
        type: u2
      - id: partitions0
        type: u2
      - id: compressed
        type: u2
      - id: segments0
        type: u2
      - id: partitions1
        type: u1
      - id: segments1
        type: u1
      - id: flash_type
        type: u1
      #we only try to handle version = 4
      #which is important for fields after this one
      - id: header_version
        type: u1
      - id: sig_realsize
        type: u2
      - id: object_version
        type: u4
      - id: depend_version
        type: u4
      - id: reserve
        size: 14
      - id: hash
        size: hash_size
      - id: signature
        size: sig_size/8
  header_ext:
    seq:
      - id: sdk_version
        size: 16
        type: str
        terminator: 0
        encoding: UTF-8
      - id: part_flag
        size: 16
     # - id: part_status
     #   type: u1
  part_info:
    seq:
      - id: name
        size: 32
        type: str
        terminator: 0
        encoding: UTF-8
      - id: flash_offset
        type: u8
      - id: length
        type: u8
      - id: is_upgrade
        type: u4
  segment_info:
    seq:
      - id: img_offset
        type: u8
      - id: flash_offset
        type: u8
      - id: compressed_size
        type: u8
      - id: decompressed_size
        type: u8
  file_body:
    params:
      - id: offset            
        type: u8
      - id: length             
        type: u8
    instances:
      body:
        pos: offset
        size: length
