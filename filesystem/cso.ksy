meta:
  id: cso
  title: Compressed ISO
  application:
    - Sony PSP custom firmwares
    - Compressed ISO9660 converter by Booster
    - maxcso
    - CSOMaker
    - PPSSPP
  file-extension:
    - cso
    - zso
  xref:
    mime: application/x-compressed-iso
    wikidata: Q2347127
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This is a file format used in Sony PSP custom firmwares to compress ISO images,
  that are on-the-fly decompressed by the kernel, to allow to place more software
  onto a flash card. Some games tolerate such procedure well, other ones have lags
  in some points, another ones become completely unenjoyable.
  AFAIK this format is not used for compressing and mounting ISO images for PCs.
  The `doc`s in this format were mostly copied from the readmes available in
  `doc-ref`s.

  The original CSO format was created by BOOSTER.
  This document includes an experimental v2 format of CSO, proposed by Unknown W.
  Brackets.
  A CSO file consists of a file header, index section, and data section.
doc-ref:
  - https://github.com/unknownbrackets/maxcso/blob/961f232cf99d546b2b7e704c0ecf3fc5bea52221/README_CSO.md
  - https://github.com/unknownbrackets/maxcso/blob/961f232cf99d546b2b7e704c0ecf3fc5bea52221/README_ZSO.md
  - https://github.com/unknownbrackets/maxcso/blob/961f232cf99d546b2b7e704c0ecf3fc5bea52221/src/input.cpp#L438-L447
  - https://github.com/lz4/lz4/blob/ebb370ca83af193212df4dcbadcc5d87bc0de2f0/doc/lz4_Block_format.md
seq:
  - id: header
    type: header
  - id: indexes
    type: index(_index)
    repeat: expr
    repeat-expr: header.count_of_indexes
    doc: |
      The final index entry indicates the end of the data segment and normally EOF.
      v2: The final index entry must not have the high bit set.
enums:
  compression:
    0: unknown
    1: none
    2: deflate
    3: lz4
types:
  index:
    params:
      - id: idx
        type: u8
    seq:
      - id: raw
        type: u4
    instances:
      ptr:
        value: (raw & 0x7FFFFFFF) << _root.header.index_shift
        doc: |
          The lower 31 bits of each index entry, when shifted left by `index_shift`,
          indicate the position within the file of the block's compressed data.  The
          length of the block is the difference between this entry's offset and the
          following index entry's offset value.
          Note that this size may be larger than the compressed or uncompressed data, if
          `index_shift` is greater than 0.  The space between blocks may be padded with
          any byte, but NUL is recommended.
          Note also that this means index entries must be incrementing.  Reordering or
          deduplication of blocks is not supported.
          zso v1: The lower 31 bits of each index entry, when shifted left by
          `index_shift`, indicate the position within the file of the block's compressed
          data.  The length of the block is the difference between this entry's offset and
          the following index entry's offset value.
          Note that this size may be larger than the compressed or uncompressed data, if
          `index_shift` is greater than 0.  The space between blocks may be padded with
          any byte, but NUL is recommended.
          Note also that this means index entries must be incrementing.  Reordering or
          deduplication of blocks is not supported.
      msb:
        value: raw >> 31 == 1
      is_end:
        value: idx == _root.header.block_count
        doc: |
          True for the final index entry, which only marks the end of the
          data segment and has no block of its own.
      size:
        value: _root.indexes[idx+1].ptr - ptr
        if: not is_end
      compression_cso_v1:
        value: 'msb ? compression::none : compression::deflate'
      compression_zso_v1:
        value: 'msb ? compression::none : compression::lz4'
      compression_cso_v2:
        value: '(size < _root.header.block_size) ? (msb ? compression::lz4 : compression::deflate) : compression::none'
        if: not is_end
      compression:
        value: |
          (
            _root.header.flavour == "C"
            ?
            (_root.header.version<=1 ? compression_cso_v1 : compression_cso_v2)
            :
            (_root.header.flavour == "Z" ? compression_zso_v1 : compression::unknown)
          )
        if: not is_end
      block_uncompressed:
        io: _root._io
        pos: ptr
        size: size
        if: not is_end
      block_deflate:
        io: _root._io
        pos: ptr
        size: size
        process: kaitai.compress.deflate
        if: not is_end and compression == compression::deflate
      block_lz4:
        io: _root._io
        pos: ptr
        size: size
        process: kaitai.compress.lz4_block(_root.header.block_size)
        if: not is_end and compression == compression::lz4
        doc: |
          A raw LZ4 block (no frame header, no size prefix) that decompresses to
          `block_size` bytes. maxcso compresses each whole block with
          `LZ4_compress_HC` / `LZ4_compress_default`, and reads it back with
          `LZ4_decompress_safe_partial` because `size` may include padding after
          the block when `index_shift` is greater than 0.
      block:
        value: '(compression == compression::deflate) ? block_deflate : ((compression == compression::lz4) ? block_lz4 : block_uncompressed)'
        if: not is_end and compression != compression::unknown
  header:
    seq:
      - id: flavour
        size: 1
        type: str
        doc: |
          "Z" for ZSO, "C" for CSO"
      - id: signature
        -orig-id: magic
        contents: ISO
      - id: header_size
        -orig-id: header_size
        type: u4
        doc: |
          v1: Does not always contain a reliable value.
          v2: Must always be 0x18
      - id: uncompressed_size
        -orig-id: uncompressed_size
        type: u8
        doc: Total size of original ISO.
      - id: block_size
        -orig-id: block_size
        type: u4
        doc: Size of each block, usually 2048.
      - id: version
        -orig-id: version
        type: u1
        doc: May be 0 or 1 (v1) or 2 (v2).
      - id: index_shift
        -orig-id: index_shift
        type: u1
        doc: Indicates left shift of index values.
      - id: reserved
        -orig-id: unused
        size: 2
        doc: May contain any values.
    instances:
      block_count:
        value: (uncompressed_size + block_size - 1) / block_size   #ceil(uncompressed_size / block_size)
      count_of_indexes:
        value: block_count + 1
