# Imported from https://gist.githubusercontent.com/spotlightishere/b77b2ba85c9323f8f89f212333cea55b/raw/6d5e2527061d68de1a6f0bd4d5e8473f1335bda5/icondatapack.yml
meta:
  id: icondatapack
  file-extension: icondatapack
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    size: 16
    type: strz
    encoding: ASCII
    doc: |
      Appears to be "ICONDATAPACK", "ICONMAPPACK",
      or "ICONCONFIGPACK".
  - id: spacing
    size: 0x30
    doc: |
      grl::codec::ResourcePack::decodeHeader
      appears to always read to 0x40 in.
  - id: chapter_amount
    type: u2
    doc: |
      Observed to be 3 within an `icondatapack`, representing
      three "chapters" within the header.
      `iconconfigpack`s appear to have 4.
  - id: chapters
    type: chapter_info
    repeat: expr
    repeat-expr: chapter_amount
    doc: Immediately follows the header.
types:
  chapter_info:
    doc: Only appears in the header.
    seq:
      - id: chapter_type
        type: u2
        doc: Seemingly always 0x1 to 0xf.
      - id: chapter_offset
        type: u8
        doc: Offset in the file from 0.
    instances:
      chapter_data:
        pos: chapter_offset
        type:
          switch-on: chapter_type
          cases:
            0x1: unk_1
            0xd: unk_d
            0xe: atlas
  unk_1:
    seq:
      - id: full_chapter_length
        type: u8
      - id: compressed_length
        type: u8
      - id: compressed_data
        size: compressed_length
  unk_d:
    seq:
      - id: full_chapter_length
        type: u8
      - id: compressed_length
        type: u8
      - id: compressed_data
        size: compressed_length
  atlas:
    doc: |
      The name Atlas was derived from an assertion message
      stating it cannot be compressed.
    seq:
      - id: full_chapter_length
        type: u8
      - id: compressed_length
        contents: [0, 0, 0, 0, 0, 0, 0, 0]
        doc: Asserted to always be zero.
      - id: image_count
        type: u2
      - id: probably_padding
        contents: [0, 0]
        doc: Never observed to be anything else.
      - id: images
        type: image_data
        repeat: expr
        repeat-expr: image_count
  image_data:
    seq:
      - id: image_length
        type: u4
      - id: data
        size: image_length
