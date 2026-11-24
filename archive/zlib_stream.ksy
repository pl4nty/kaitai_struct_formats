meta:
  id: zlib_stream
  title: zlib compressed data format
  file-extension: zz
  xref:
    mime: application/zlib
    rfc: 1950
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  The zlib wrapper (RFC 1950) around a DEFLATE (RFC 1951) compressed
  stream, as produced by zlib's `compress()` / `deflate()` with default
  settings and used inside PNG, PDF, Git objects and many other
  formats. It is a 2-byte header (compression method / window size and
  flags with a check value making the header a multiple of 31), an
  optional 4-byte preset dictionary identifier, the compressed data and
  an Adler-32 checksum of the uncompressed data.

  This spec expects the zlib stream to occupy the whole input (data
  appearing after ADLER32 is not part of the zlib stream, but a stream
  cannot be delimited without decoding DEFLATE). The DEFLATE bit stream
  itself is not parsed; `decompressed` provides the inflated data via
  Kaitai Struct's built-in `zlib` process (not usable when a preset
  dictionary is required).
doc-ref: https://github.com/madler/zlib/blob/develop/doc/rfc1950.txt
seq:
  - id: cmf
    -orig-id: CMF
    type: u1
    doc: Compression method (low 4 bits) and compression info (high 4 bits).
  - id: flg
    -orig-id: FLG
    type: u1
    valid:
      expr: (cmf * 256 + _) % 31 == 0
    doc: |
      FCHECK (bits 0-4), FDICT (bit 5), FLEVEL (bits 6-7). FCHECK is
      chosen so that `cmf * 256 + flg` is a multiple of 31.
  - id: dict_id
    -orig-id: DICTID
    type: u4
    if: has_preset_dict
    doc: Adler-32 checksum of the preset dictionary.
  - id: body
    size: _io.size - _io.pos - 4
    doc: Compressed data (raw DEFLATE stream when `compression_method` is `deflate`).
  - id: adler32
    -orig-id: ADLER32
    type: u4
    doc: Adler-32 checksum of the uncompressed data (excluding any dictionary).
instances:
  compression_method:
    -orig-id: CM
    value: cmf & 0x0f
    enum: compression_methods
  compression_info:
    -orig-id: CINFO
    value: cmf >> 4
    doc: For deflate, base-2 logarithm of the LZ77 window size minus 8 (at most 7).
  window_size:
    value: '1 << (compression_info + 8)'
    if: compression_method == compression_methods::deflate
  has_preset_dict:
    -orig-id: FDICT
    value: flg & 0x20 != 0
  compression_level:
    -orig-id: FLEVEL
    value: flg >> 6
    enum: compression_levels
    doc: Informational only; not needed for decompression.
  decompressed:
    pos: 0
    size-eos: true
    process: zlib
    if: compression_method == compression_methods::deflate and not has_preset_dict
enums:
  compression_methods:
    8: deflate
    15: reserved
  compression_levels:
    0: fastest
    1: fast
    2: default
    3: maximum
