# Imported from https://github.com/efonte/patapon-re/blob/7cc421a84994521e4e7692dfc8adf3f7fcb781b5/Kaitai Struct/patapon_pak.ksy
# Licence and copyright: see _community/README.md
meta:
  id: patapon_pak
  title: Patapon PS4 (pak)
  file-extension: pak
  license: MIT
  endian: le
seq:
  - id: header
    type: header
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: header.num_entries

types:
  header:
    seq:
      - id: magic
        contents: ["PAKF"]
      - id: padding1
        size: 4
      - id: num_entries
        type: u4
      - id: padding2
        size: 4

  entry:
    seq:
      - id: name
        size: 0x40
        type: strz
        encoding: UTF-8
      - id: width
        type: u4
      - id: height
        type: u4
      - id: size
        type: u4
      - id: size_pixels
        type: u4
