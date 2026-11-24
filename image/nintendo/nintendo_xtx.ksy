# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/switch/xtx.ksy
meta:
  id: nintendo_xtx
  title: Nintendo Switch XTX texture container
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Nintendo Switch XTX texture container ("DFvN"). "HBvN" blocks follow the
  header; block type 2 is a fixed 120-byte texture header, block type 3 is
  that texture's Tegra block-linear pixel payload, paired in order. Only the
  block envelope is modeled here.
seq:
  - id: magic
    contents: "DFvN"
  - id: header_size
    type: u4
  - id: version_major
    type: u4
  - id: version_minor
    type: u4
  - id: blocks
    type: block_t
    repeat: eos
types:
  block_t:
    seq:
      - id: magic
        contents: "HBvN"
      - id: block_size
        type: u4
      - id: data_size
        type: u8
      - id: data_offset
        type: s8
        doc: Relative to the start of this block.
      - id: block_type
        type: u4
      - id: index
        type: u4
      - id: body
        size: block_size - 32
