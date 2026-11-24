# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/bzip2.ksy
meta:
  id: wiimms_wbz
  title: Wiimms WBZ/WLZ container around a BZIP2 stream
  file-extension:
    - wbz
    - wlz
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  BZIP2 itself is Julian Seward's standard block-sorting compression format
  (http://www.bzip.org/1.0.5/bzip2-manual-1.0.5.html). That bare stream is
  what a plain .bz2 file contains, and is modeled here as `bzip2_stream`; the
  bit-packed Huffman/BWT block payload itself is not.

  The container is a 4-byte magic followed by a verbatim copy of the first 8
  bytes of the *uncompressed* data -- so a magic-sniffer can identify the
  decompressed content's real format (e.g. spot a U8/BRRES/BREFF payload)
  without having to inflate anything -- and then the compressed stream
  itself.
seq:
  - id: magic
    contents: "WBZa"
  - id: uncompressed_magic
    size: 8
    doc: |
      Verbatim copy of the first 8 bytes of the decompressed payload,
      kept here purely so file-type detection doesn't need to decompress
      first.
  - id: compressed_payload
    size-eos: true
    type: bzip2_stream
    doc: |
      The wrapped compressed stream (bzip2 for WBZ; for a WLZ file this is an LZMA
      stream instead and not modeled the same way).
types:
  bzip2_stream:
    seq:
      - id: bzh_magic
        contents: "BZh"
      - id: level
        size: 1
        type: str
        encoding: ASCII
        doc: Compression level as an ASCII digit, '1' (fastest/smallest blocks) to '9'.
      - id: block_magic
        contents: [0x31, 0x41, 0x59, 0x26, 0x53, 0x59]
        doc: |
          Fixed per-block magic "1AY&SY'" (0x314159265359); every
          compressed block in the stream starts with this. A stream ends
          with the alternate magic 0x177245385090 ("EOS") instead of
          another block magic; not modeled here since it only shows up
          after the last block, deep inside the bit-packed payload.
      - id: rest
        size-eos: true
        doc: Bit-packed Huffman/BWT-coded block data, not modeled.
