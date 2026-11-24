# Imported from https://github.com/RetroReversing/retroReversing/blob/2a38ef67731f2952f36c74207225dbee638e1ef0/public/js/file-lab/plugins/kaitai-viewer/formats/common/iff.ksy
meta:
  id: iff
  title: EA IFF 85 chunk container
  xref:
    wikidata: Q1145771
  license: CC0-1.0
  encoding: ASCII
  endian: be
doc: |
  EA IFF 85 (Electronic Arts Interchange File Format) represents binary
  data as a sequence of chunks. Each chunk has a 4-byte type id, a
  32-bit big-endian size, and a data payload. Odd-sized payloads are
  followed by a zero pad byte.

  ILBM, AIFF, and many Amiga-era formats build on this chunk layer.
doc-ref: https://wiki.amigaos.net/wiki/IFF
types:
  chunk:
    seq:
      - id: id
        size: 4
        type: str
        encoding: ASCII
      - id: len
        type: u4
      - id: body_slot
        size: len
        type: body_slot
      - id: pad
        size: len % 2
    types:
      body_slot: {}
