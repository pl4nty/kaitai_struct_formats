# Imported from https://github.com/jiegec/fatbinary/blob/7856d02eb17321787df2e342442245b5c725b9f3/fatbinary.ksy
# Licence and copyright: see _community/README.md
meta:
  id: cuda_fatbin
  file-extension: fatbin
  license: MIT
  endian: le
seq:
  - id: header
    type: header
  - id: entry1
    type: entry
    repeat: eos
types:
  header:
    seq:
      - id: magic
        size: 4
      - id: version
        size: 2
      - id: header_size
        type: u2
      - id: size
        type: u8
  entry:
    seq:
      - id: kind
        type: u2
      - id: unknown1
        type: u2
      - id: header_size
        type: u4
      - id: size
        type: u8
      - id: compressed_size
        type: u4
      - id: unknown2
        type: u4
      - id: minor
        type: u2
      - id: major
        type: u2
      - id: arch
        type: u4
      - id: obj_name_offset
        type: u4
      - id: obj_name_len
        type: u4
      - id: flags
        type: u8
      - id: zero
        type: u8
      - id: decompressed_size
        type: u8
      - id: padding
        size: header_size - 64
      - id: payload
        size: size
