# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/crilayla.ksy
meta:
  id: cri_layla
  title: CRIWARE CRILAYLA compressed block
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  CRILAYLA compression, used to compress individual CPK archive members
  (see `cpk`). The header carries the decompressed size of everything
  after a 0x100-byte uncompressed header copy; the compressed payload
  itself is a backwards LZ-style bitstream (not modelled here as a
  struct, since it is decoded bit-by-bit rather than as fixed fields).
seq:
  - id: magic
    size: 8
    type: str
    encoding: ASCII
    valid: '"CRILAYLA"'
  - id: len_compressed
    type: u4
    doc: |
      Size of the compressed data that follows, excluding this header and the
      uncompressed-header copy.
  - id: len_uncompressed_header
    type: u4
    doc: |
      Size of the uncompressed header copy appended after the compressed data
      (typically 0x100).
  - id: compressed_data
    size: len_compressed
  - id: uncompressed_header
    size: len_uncompressed_header
