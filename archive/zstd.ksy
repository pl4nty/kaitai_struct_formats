meta:
  id: zstd
  title: Zstandard compressed data
  application: zstd
  file-extension: zst
  xref:
    mime: application/zstd
    rfc: 8878
  license: CC0-1.0
  ks-version: '0.10'
  endian: le
doc: |
  Zstandard (zstd) is a lossless compression format. A `.zst` file is a
  sequence of one or more independent frames. A Zstandard frame consists of a
  frame header, one or more blocks and an optional content checksum. Skippable
  frames carry arbitrary user data and are ignored by decoders.

  This specification covers the frame layer completely: magic numbers, frame
  header (window descriptor, dictionary ID, frame content size), block headers,
  skippable frames and the content checksum. For compressed blocks, it parses
  the literals section header and splits the block content into the literals
  section data and the sequences section; Huffman trees, FSE tables and the
  bitstreams themselves are kept as raw bytes, as they cannot be described
  sensibly in a declarative way. Standalone dictionaries produced by
  `zstd --train` (magic 0xEC30A437) are not covered by this spec.

  The original Zstandard compression format specification has the following
  notice:

  Copyright (c) Meta Platforms, Inc. and affiliates.

  Permission is granted to copy and distribute this document for any purpose
  and without charge, including translations into other languages and
  incorporation into compilations, provided that the copyright notice and this
  notice are preserved, and that any substantive changes or deletions from the
  original are clearly marked. Distribution of this document is unlimited.
doc-ref:
  - https://github.com/facebook/zstd/blob/dev/doc/zstd_compression_format.md
  - https://www.rfc-editor.org/rfc/rfc8878
seq:
  - id: frames
    type: frame
    repeat: eos
types:
  frame:
    seq:
      - id: magic
        type: u4
        valid:
          expr: _ == 0xfd2fb528 or _ & 0xffff_fff0 == 0x184d_2a50
      - id: zstd_frame
        type: zstd_frame
        if: not is_skippable
      - id: skippable_frame
        type: skippable_frame
        if: is_skippable
    instances:
      is_skippable:
        value: magic & 0xffff_fff0 == 0x184d_2a50
  skippable_frame:
    doc: |
      Frame with user-defined metadata. Its magic number is any value from
      0x184D2A50 to 0x184D2A5F (compatible with LZ4 skippable frames).
    seq:
      - id: len_user_data
        type: u4
      - id: user_data
        size: len_user_data
  zstd_frame:
    seq:
      - id: frame_header
        type: frame_header
      - id: blocks
        type: block
        repeat: until
        repeat-until: _.last_block
      - id: content_checksum
        type: u4
        if: frame_header.descriptor.content_checksum_flag
        doc: |
          Lower 4 bytes of the XXH64 (seed 0) hash of the decompressed
          content of this frame.
  frame_header:
    seq:
      - id: descriptor
        type: frame_header_descriptor
      - id: window_descriptor
        type: window_descriptor
        if: not descriptor.single_segment_flag
      - id: dictionary_id
        type:
          switch-on: descriptor.dictionary_id_flag
          cases:
            1: u1
            2: u2
            3: u4
        if: descriptor.dictionary_id_flag != 0
        doc: |
          ID of the dictionary required to decode the frame. A value of 0 has
          the same meaning as no dictionary ID.
      - id: frame_content_size_raw
        type:
          switch-on: descriptor.frame_content_size_flag
          cases:
            0: u1
            1: u2
            2: u4
            3: u8
        if: has_frame_content_size
        doc: Use `frame_content_size` instead (it applies the 256 offset).
    instances:
      has_frame_content_size:
        value: descriptor.frame_content_size_flag != 0 or descriptor.single_segment_flag
      frame_content_size:
        value: 'descriptor.frame_content_size_flag == 1 ? frame_content_size_raw + 256 : frame_content_size_raw'
        if: has_frame_content_size
        doc: Size of the decompressed content of the frame.
  frame_header_descriptor:
    seq:
      - id: frame_content_size_flag
        type: b2
      - id: single_segment_flag
        type: b1
        doc: |
          If set, the window descriptor is absent and the window size equals
          the frame content size, which is then always present.
      - id: unused_bit
        type: b1
      - id: reserved_bit
        type: b1
        valid: false
      - id: content_checksum_flag
        type: b1
      - id: dictionary_id_flag
        type: b2
  window_descriptor:
    seq:
      - id: exponent
        type: b5
      - id: mantissa
        type: b3
    instances:
      window_log:
        value: 10 + exponent
      window_size:
        value: (1 << window_log) + (1 << window_log) / 8 * mantissa
        doc: |
          Minimum memory buffer size needed to decode the frame, in bytes:
          `windowBase + (windowBase / 8) * Mantissa`, where
          `windowBase = 1 << (10 + Exponent)`.
  block:
    seq:
      - id: header
        type: block_header
      - id: content
        size: 'header.block_type == block_type::rle ? 1 : header.block_size'
        type:
          switch-on: header.block_type
          cases:
            block_type::compressed: compressed_block
        doc: |
          For raw blocks, the uncompressed data. For RLE blocks, the single
          byte to be repeated `header.block_size` times.
    instances:
      last_block:
        value: header.last_block
  block_header:
    meta:
      bit-endian: le
    seq:
      - id: last_block
        type: b1
      - id: block_type
        type: b2
        enum: block_type
        valid:
          expr: _ != block_type::reserved
      - id: block_size
        type: b21
        doc: |
          For raw and compressed blocks, the size of the block content. For
          RLE blocks, the number of times the content byte is repeated.
  compressed_block:
    seq:
      - id: literals_section_header
        type: literals_section_header
      - id: literals_data
        size: 'literals_section_header.literals_block_type == literals_block_type::rle ? 1 : literals_section_header.literals_data_size'
        doc: |
          For raw literals, the literals themselves. For RLE literals, the
          byte to be repeated `literals_section_header.regenerated_size`
          times. For compressed and treeless literals, the optional Huffman
          tree description, the optional jump table and 1 or 4 Huffman-coded
          streams.
      - id: sequences_section
        size-eos: true
        doc: |
          Sequences section: number of sequences, symbol compression modes,
          FSE table descriptions and the sequences bitstream.
  literals_section_header:
    meta:
      bit-endian: le
    seq:
      - id: literals_block_type
        type: b2
        enum: literals_block_type
      - id: size_format_lo
        type: b1
      - id: size_format_hi
        type: b1
      # Raw and RLE literals
      - id: regenerated_size_5_hi
        type: b4
        if: not is_compressed and not size_format_lo
        doc: Upper 4 bits of a 5-bit regenerated size; bit 0 is `size_format_hi`.
      - id: regenerated_size_12
        type: b12
        if: not is_compressed and size_format == 1
      - id: regenerated_size_20
        type: b20
        if: not is_compressed and size_format == 3
      # Compressed and treeless literals
      - id: regenerated_size_10
        type: b10
        if: is_compressed and size_format_hi == false
      - id: compressed_size_10
        type: b10
        if: is_compressed and size_format_hi == false
      - id: regenerated_size_14
        type: b14
        if: is_compressed and size_format == 2
      - id: compressed_size_14
        type: b14
        if: is_compressed and size_format == 2
      - id: regenerated_size_18
        type: b18
        if: is_compressed and size_format == 3
      - id: compressed_size_18
        type: b18
        if: is_compressed and size_format == 3
    instances:
      is_compressed:
        value: literals_block_type == literals_block_type::compressed or literals_block_type == literals_block_type::treeless
        doc: True for Huffman-compressed literals (with or without a tree description).
      size_format:
        value: '(size_format_hi ? 2 : 0) + (size_format_lo ? 1 : 0)'
      num_streams:
        value: 'is_compressed and size_format != 0 ? 4 : 1'
        doc: Number of Huffman-coded streams in the literals section.
      regenerated_size:
        value: >-
          is_compressed
            ? (size_format_hi == false ? regenerated_size_10 : size_format == 2 ? regenerated_size_14 : regenerated_size_18)
            : (not size_format_lo ? (size_format_hi ? 1 : 0) + regenerated_size_5_hi * 2 : size_format == 1 ? regenerated_size_12 : regenerated_size_20)
        doc: Number of literals after decoding.
      compressed_size:
        value: 'size_format_hi == false ? compressed_size_10 : size_format == 2 ? compressed_size_14 : compressed_size_18'
        if: is_compressed
        doc: |
          Size of the compressed literals, including the Huffman tree
          description when present.
      literals_data_size:
        value: 'is_compressed ? compressed_size : regenerated_size'
        doc: |
          Size of the literals data following this header (except for RLE, which is always
          1).
enums:
  block_type:
    0: raw
    1: rle
    2: compressed
    3: reserved
  literals_block_type:
    0: raw
    1: rle
    2: compressed
    3: treeless
