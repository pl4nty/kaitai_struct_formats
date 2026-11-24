# Imported from https://github.com/Game3DEE/darkstone/blob/afc3261693b91fcd371e975889d788dfded04311/src/kaitai/mtf.ksy
# Licence and copyright: see _community/README.md
meta:
  id: darkstone_mtf
  title: Darkstone Archive format
  application: All Darkstone versions
  file-extension: mtf
  license: MIT
  encoding: UTF-8
  endian: le

seq:
  - id: file_count
    type: u4
  - id: files
    type: file
    repeat: expr
    repeat-expr: file_count
    # After this follows the actual file data
    # see the instances of type 'file' for details

types:
  file:
    seq:
      - id: name_len
        type: u4
      - id: name
        size: name_len
        type: strz
      - id: offset
        type: u4
      - id: size
        type: u4
    instances:
      raw_data:
        pos: offset
        size: size
      compression_header:
        pos: offset
        type: compression_header
      is_compressed:
        value: compression_header.magic == 0x0BADBEAF

  compression_header:
    seq:
      - id: magic
        type: u4
      - id: compressed_size
        type: u4
        if: magic == 0x0BADBEAF
      - id: decompressed_size
        type: u4
        if: magic == 0x0BADBEAF
