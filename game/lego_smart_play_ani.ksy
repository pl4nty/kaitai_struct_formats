# Imported from https://github.com/nathankellenicki/node-smartplay/blob/5b467064cceeea372506bf54a6671c94980318ad/research/tools/p11_ani.ksy
# Licence and copyright: see _community/README.md
meta:
  id: lego_smart_play_ani
  title: "LEGO Smart Play ANI (Animation Data)"
  file-extension: bin
  license: MIT
  endian: le

doc: |
  ANI format from animation.bin inside ROFS. Contains LED animation sequences
  indexed by structured clip IDs. Magic is 0x7F ANI.

seq:
  - id: header
    type: header
  - id: clip_ids
    type: u4
    repeat: expr
    repeat-expr: header.num_clips
    doc: |
      Clip ID table. Each u32 encodes [index:8][bank:8][type:8][reserved:8] in
      little-endian
  - id: clip_offsets
    type: clip_offset
    repeat: expr
    repeat-expr: header.num_clips
  - id: clip_data
    size-eos: true
    doc: Raw LED animation clip data

types:
  header:
    seq:
      - id: magic
        contents: [0x7F, 0x41, 0x4E, 0x49]
        doc: "Magic bytes: 0x7F A N I"
      - id: num_banks
        type: u2
        doc: "Number of animation banks (observed: 9)"
      - id: num_clips
        type: u2
        doc: "Number of animation clips (observed: 135)"

  clip_offset:
    doc: 8-byte entry pointing to clip data within this file
    seq:
      - id: offset
        type: u4
        doc: Absolute file offset to clip data
      - id: size
        type: u4
        doc: Clip data size in bytes
