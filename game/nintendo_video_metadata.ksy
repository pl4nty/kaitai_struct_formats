# Imported from https://github.com/Nintendo-Video-research-project/Kaitais/blob/d5e1ee1f171a6361fd23b08ad0c1f66a53e764e2/kaitais/metadata.ksy
meta:
  id: nintendo_video_metadata
  title: Nintendo Video episode metadata
  license: LicenseRef-All-Rights-Reserved
  imports:
    - nintendo_video_links
    - nintendo_video_timestamp
    - /common/vlq_base128_be
  endian: le

seq:
  - id: len
    type: u4

  - id: vid_id
    size: 0x20
    type: str
    terminator: 0
    encoding: UTF-8
    doc: Fixed 32-byte string buffer for the video identifier
  
  - id: release
    type: nintendo_video_timestamp

  - id: expire
    type: nintendo_video_timestamp

  - id: vid_title
    size: 0x78
    type: str
    terminator: 0
    encoding: UTF-16BE

  - id: unknown
    size: 0x8
    doc: Padding?

  - id: vid_len
    type: u4
    doc: Duration or length context of video

  - id: vid_desc
    type: str
    terminator: 0
    encoding: UTF-16BE
    doc: UTF-16 video description string payload

  - id: moflex_size
    type: vlq_base128_be
    if: not _io.eof

  - id: moflex_data
    size-eos: true # 🚀 BYPASS: Safely consumes remaining data instead of crashing on the 1GB bug
    if: not _io.eof

  - id: thumbnail_size
    type: vlq_base128_be
    if: not _io.eof
    doc: Size identifier tag driving the JPEG image asset slice

  - id: thumbnail_data
    size: thumbnail_size.value
    if: not _io.eof and thumbnail_size.value > 0
    doc: Raw binary JPEG thumbnail graphic entry data

  - id: interactive_data_size
    type: u4
    if: not _io.eof
    doc: Size identifier driving the underlying links block array

  - id: interactive_links_data
    size: interactive_data_size
    type: nintendo_video_links
    if: not _io.eof and interactive_data_size > 0
    doc: Direct layout configuration parsing data mapped to your links.ksy schemas
