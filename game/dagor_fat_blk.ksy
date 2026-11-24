# Imported from https://github.com/kotiq/blk/blob/636f1d94ca4f7aaad0f29a76d3dfbbde3f9eef9c/src/formats/game/dagor_fat_blk.ksy
meta:
  id: dagor_fat_blk
  title: DagorEngine fat datablock
  file-extension: blk
  license: LicenseRef-All-Rights-Reserved
  imports:
    - dagor_blk_data

seq:
  - id: type
    contents: [1]
  - id: data
    type: dagor_blk_data
