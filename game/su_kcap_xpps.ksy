# Imported from https://github.com/MaouAnimus/YoteiPort/blob/7994dfaa023691469ac0f6b03a96afe55896f47c/tools/kcap_xpps.ksy
meta:
  id: su_kcap_xpps
  title: Sucker Punch Ghost of Yotei KCAP Package (.xpps)
  file-extension: xpps
  license: MIT
  endian: le

doc: |
  Sucker Punch Productions KCAP ("PACK" reversed) v30.41 container format
  used in Ghost of Yotei (`.xpps`, `.sprig.xpps`) for shaders, animations,
  world sectors (`hok_*`, `sek_*`), and audio banks.
  Blocks are either uncompressed or Oodle Kraken compressed (first byte 0x8C).

seq:
  - id: magic
    contents: "KCAP"
  - id: version_minor
    type: u2
  - id: version_major
    type: u2
  - id: flags_1
    type: u4
  - id: flags_2
    type: u4
  - id: unk_10
    type: u8
  - id: section_count
    type: u8
  - id: content_hash
    size: 16
  - id: reserved_30
    size: 16
  - id: header_size
    type: u4
  - id: block_table_region_size
    type: u4
  - id: payload_offset
    type: u4
  - id: total_file_size
    type: u4
  - id: unk_50
    type: u8
  - id: stream_count
    type: u8
  - id: unk_60
    size: 48
  - id: streams
    type: stream_descriptor
    repeat: expr
    repeat-expr: stream_count
  - id: block_descriptors
    type: block_descriptor
    repeat: expr
    repeat-expr: streams[0].block_count

types:
  stream_descriptor:
    seq:
      - id: stream_type
        type: u4
      - id: stream_size
        type: u4
      - id: stream_offset
        type: u8
      - id: reserved
        type: u8
      - id: stream_id
        type: u8
      - id: block_count
        type: u8

  block_descriptor:
    seq:
      - id: compressed_size
        type: u4
      - id: relative_offset
        type: u4
      - id: flags_and_type
        type: u4
