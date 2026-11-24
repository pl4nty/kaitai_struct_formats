# Imported from https://github.com/PaulKuzmin/Ja2EditorLib/blob/51bd04236ac8541e61c9bdc4b7a27eebfc81bac7/Ja2SlfLib/kaitai/sti.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ja2_stci
  title: STCI Header (Sir-Tech's Crazy Image)
  license: MIT
  endian: le

seq:
  - id: file_identifier
    size: 4
    type: str
    encoding: ASCII
    doc: Must be "STCI"
  - id: initial_size
    type: u4
    doc: Size of image data before compression
  - id: size_after_compression
    type: u4
    doc: Size of image data after compression
  - id: transparent_color
    type: u4
    doc: Index or color treated as transparent
  - id: flags
    type: u4
    doc: Bit flags controlling image type
  - id: height
    type: u2
  - id: width
    type: u2
  - id: format_specific_header
    size: 20
    doc: Either 8-bit or 16-bit subheader depending on flags
  - id: color_depth
    type: u1
  - id: reserved1
    size: 3
  - id: aux_data_size
    type: u4
    doc: Optional auxiliary data section size
  - id: reserved2
    size: 12

instances:
  is_aux_object_data:
    value: (flags & 0x01) != 0
  is_rgb:
    value: (flags & 0x04) != 0
  is_indexed:
    value: (flags & 0x08) != 0
  is_zlib:
    value: (flags & 0x10) != 0
  is_etrle:
    value: (flags & 0x20) != 0
