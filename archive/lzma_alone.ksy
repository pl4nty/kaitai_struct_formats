# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/lzma_alone.ksy
meta:
  id: lzma_alone
  title: LZMA alone (.lzma) stream
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Standalone ".lzma" stream. Fixed 13-byte header: 5 property bytes (1 byte
  encoding lc/lp/pb, then a 4-byte dictionary size) plus an 8-byte
  little-endian uncompressed size (0xFFFFFFFFFFFFFFFF when
  unknown/streamed), followed by the raw LZMA-compressed range-coder stream.
seq:
  - id: properties
    type: u1
    doc: (pb * 5 + lp) * 9 + lc, i.e. 0x5D for the common lc=3,lp=0,pb=2.
  - id: dict_size
    type: u4
  - id: uncompressed_size
    type: u8
    doc: 0xFFFFFFFFFFFFFFFF means unknown (streamed end-of-stream marker used instead).
  - id: compressed_stream
    size-eos: true
