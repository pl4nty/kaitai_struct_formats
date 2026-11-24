# Imported from https://github.com/kotiq/blk/blob/636f1d94ca4f7aaad0f29a76d3dfbbde3f9eef9c/src/formats/game/dagor_slim_zstd_dict_blk.ksy
meta:
  id: dagor_slim_zstd_dict_blk
  title: DagorEngine Zstd compressed with a dict slim datablock
  file-extension: blk
  license: LicenseRef-All-Rights-Reserved
  endian: le


seq:
  - id: type
    contents: [5]
  - id: zstd_with_dict_data_stream
    size-eos: True
