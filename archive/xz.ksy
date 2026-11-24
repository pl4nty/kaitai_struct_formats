meta:
  id: xz
  title: .xz compressed file
  application: XZ Utils
  file-extension:
    - xz
    - txz
  xref:
    mime: application/x-xz
  license: CC0-1.0
  ks-version: '0.10'
  imports:
    - /common/vlq_base128_le
  endian: le
doc: |
  The .xz container format of XZ Utils: a Stream Header, zero or more
  Blocks of filtered (typically LZMA2-compressed) data, an Index listing
  the sizes of all Blocks, and a Stream Footer. All fields are aligned
  to four bytes.

  Block headers are not required to record the compressed size of their
  data (single-threaded `xz` does not), so Blocks cannot in general be
  walked forwards. This spec therefore parses the Stream Footer at the
  end of the file, uses its Backward Size to locate the Index, and
  computes the position of every Block from the Unpadded Sizes recorded
  in the Index, exactly as random-access decoders do.

  Coverage: the Stream that ends the file. For the usual single-Stream
  file (the output of `xz`, `xz -T0`, Python `lzma` and most other
  writers) that is the whole file. When several Streams are
  concatenated, `stream_header` is the header of the first Stream,
  while `last_stream_header`, the Index and the Blocks belong to the
  last one; earlier Streams and Stream Padding between them are not
  described. A file that ends with Stream Padding (null bytes after
  the last Stream Footer) is not supported, since finding the footer
  would require scanning backwards. The compressed data itself (LZMA2
  and the BCJ / Delta filters) is not decoded.
doc-ref: https://github.com/tukaani-project/xz/blob/master/doc/xz-file-format.txt
seq:
  - id: stream_header
    type: stream_header
instances:
  ofs_stream_footer:
    value: _io.size - 12
  stream_footer:
    pos: ofs_stream_footer
    type: stream_footer
  len_index:
    value: (stream_footer.backward_size + 1) * 4
    doc: Real size of the Index (Backward Size is stored as size / 4 - 1).
  ofs_index:
    value: ofs_stream_footer - len_index
  index:
    pos: ofs_index
    size: len_index
    type: index
  ofs_last_stream:
    value: ofs_index - index.len_blocks - 12
    doc: |
      Offset of the Stream Header of the Stream that ends the file; 0
      unless several Streams are concatenated.
  last_stream_header:
    pos: ofs_last_stream
    type: stream_header
    if: ofs_last_stream != 0
  ofs_blocks:
    value: ofs_last_stream + 12
  len_check:
    value: 'stream_footer.flags.check_type == check_types::none ? 0 : 4 << ((stream_footer.flags.check_type.to_i - 1) / 3)'
    doc: Size of the Check field at the end of every Block (0, 4, 8, 16, 32 or 64 bytes).
types:
  stream_header:
    seq:
      - id: magic
        contents: [0xfd, "7zXZ", 0x00]
      - id: flags
        type: stream_flags
      - id: crc32
        type: u4
        doc: CRC32 of `flags`.
  stream_footer:
    seq:
      - id: crc32
        type: u4
        doc: CRC32 of `backward_size` and `flags`.
      - id: backward_size
        type: u4
      - id: flags
        type: stream_flags
        doc: Copy of the Stream Flags from the Stream Header.
      - id: magic
        contents: "YZ"
  stream_flags:
    seq:
      - id: reserved1
        type: u1
        valid: 0
      - id: reserved2
        type: b4
        valid: 0
      - id: check_type
        type: b4
        enum: check_types
        doc: Integrity check stored after each Block's compressed data.
  index:
    seq:
      - id: indicator
        contents: [0x00]
        doc: Distinguishes the Index from a Block Header, whose first byte is never 0.
      - id: num_records
        type: vlq_base128_le
      - id: records
        type: 'record(_index == 0 ? 0 : records[_index - 1].ofs_block_end)'
        repeat: expr
        repeat-expr: num_records.value
      - id: padding
        size: (4 - _io.pos % 4) % 4
      - id: crc32
        type: u4
        doc: CRC32 of the Index except this field.
    instances:
      len_blocks:
        value: 'num_records.value == 0 ? 0 : records.last.ofs_block_end'
        doc: Total size of all (padded) Blocks of the Stream.
  record:
    doc: Index entry describing one Block.
    params:
      - id: ofs_block
        type: u8
        doc: |
          Offset of the Block relative to the end of the Stream Header:
          0 for the first Block, each next one follows the previous padded
          Block.
    seq:
      - id: len_unpadded
        -orig-id: Unpadded Size
        type: vlq_base128_le
        doc: |
          Size of the Block Header, Compressed Data and Check fields, i.e.
          size of the Block without its Block Padding.
      - id: len_uncompressed
        -orig-id: Uncompressed Size
        type: vlq_base128_le
    instances:
      len_block_padded:
        value: (len_unpadded.value + 3) / 4 * 4
      ofs_block_end:
        value: ofs_block + len_block_padded
      block:
        io: _root._io
        pos: _root.ofs_blocks + ofs_block
        size: len_unpadded.value
        type: block
  block:
    seq:
      - id: len_header_div4
        -orig-id: Block Header Size
        type: u1
        valid:
          min: 1
        doc: Real Block Header size is `(len_header_div4 + 1) * 4` bytes.
      - id: header
        size: (len_header_div4 + 1) * 4 - 1
        type: block_header
      - id: compressed_data
        size: _io.size - _io.pos - _root.len_check
      - id: check
        size: _root.len_check
        doc: Check (CRC32, CRC64 or SHA-256) of the uncompressed data.
  block_header:
    doc: Block Header after its size byte.
    seq:
      - id: has_len_uncompressed
        type: b1
        doc: Block Flags bit 7 (0x80).
      - id: has_len_compressed
        type: b1
        doc: Block Flags bit 6 (0x40).
      - id: reserved
        type: b4
        valid: 0
      - id: num_filters_minus_1
        type: b2
        doc: Block Flags bits 0-1 (0x03).
      - id: len_compressed
        -orig-id: Compressed Size
        type: vlq_base128_le
        if: has_len_compressed
      - id: len_uncompressed
        -orig-id: Uncompressed Size
        type: vlq_base128_le
        if: has_len_uncompressed
      - id: filters
        type: filter_flags
        repeat: expr
        repeat-expr: num_filters_minus_1 + 1
        doc: Filter chain; the last one is applied first when decoding.
      - id: padding
        size: _io.size - _io.pos - 4
      - id: crc32
        type: u4
        doc: CRC32 of the whole Block Header except this field.
  filter_flags:
    seq:
      - id: filter_id
        type: vlq_base128_le
      - id: len_properties
        type: vlq_base128_le
      - id: properties
        size: len_properties.value
        doc: |
          For LZMA2 one byte whose low 6 bits encode the dictionary size;
          for BCJ filters optionally a u4 start offset; for Delta one
          byte holding distance - 1.
    instances:
      filter:
        value: filter_id.value
        enum: filter_ids
enums:
  check_types:
    0x0: none
    0x1: crc32
    0x4: crc64
    0xa: sha256
  filter_ids:
    0x03: delta
    0x04: x86
    0x05: powerpc
    0x06: ia64
    0x07: arm
    0x08: arm_thumb
    0x09: sparc
    0x0a: arm64
    0x0b: riscv
    0x21: lzma2
