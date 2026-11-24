# Imported from https://github.com/MaouAnimus/YoteiPort/blob/7994dfaa023691469ac0f6b03a96afe55896f47c/tools/xtbs_sps.ksy
meta:
  id: su_xtbs_sps
  title: Sucker Punch Ghost of Yotei XTBS Texture (.sps)
  file-extension: sps
  license: MIT
  endian: le

doc: |
  Sucker Punch Productions XTBS ("SBTX" reversed) v1.30.0.0 texture container
  used in Ghost of Yotei (`cache_ps5/bitmaps/*.sps`).
  Contains two 0xbadbad13 sentinels separating the compressed name block,
  the 24-byte AGC texture descriptor, and the raw/tiled texel payload.

seq:
  - id: magic
    contents: "XTBS"
  - id: version_major
    type: u1
  - id: version_minor
    type: u1
  - id: flags
    type: u2
  - id: content_hash
    size: 16
  - id: total_file_size
    type: u4
  - id: unk_1c
    type: u4
  - id: encoded_name_len
    type: u4
  - id: raw_name_len
    type: u4
  - id: encoded_name
    size: encoded_name_len
  - id: sentinel_1
    contents: [0x13, 0xad, 0xdb, 0xba]
  - id: unk_desc_0
    type: u4
  - id: asset_id_hash
    type: u8
  - id: agc_format
    type: u2
  - id: tile_mode
    type: u1
  - id: swizzle_flags
    type: u1
  - id: width
    type: u2
  - id: height
    type: u2
  - id: depth_or_array
    type: u2
  - id: mip_levels
    type: u2
  - id: sentinel_2
    contents: [0x13, 0xad, 0xdb, 0xba]
  - id: texel_payload
    size-eos: true
