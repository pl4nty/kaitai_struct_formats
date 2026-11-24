# Imported from https://github.com/kotiq/blk/blob/636f1d94ca4f7aaad0f29a76d3dfbbde3f9eef9c/src/formats/game/dagor_bbf3_zlib_blk.ksy
meta:
  id: dagor_bbf3_zlib_blk
  title: DagorEngine Zlib compressed BBF datablock
  file-extension: blk
  license: LicenseRef-All-Rights-Reserved
  endian: le


seq:
  - id: header
    type: header
  - id: data
    type: data


types:
  header:
    seq:
      - id: magic
        contents: "\x00BBz"
      - id: size
        type: u4

  data:
    seq:
      - id: size
        type: u4
      - id: zlib_data_stream
        size: size
