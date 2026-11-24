# Imported from https://github.com/kotiq/blk/blob/636f1d94ca4f7aaad0f29a76d3dfbbde3f9eef9c/src/formats/game/dagor_slim_blk.ksy
meta:
  id: dagor_slim_blk
  title: DagorEngine slim datablock
  file-extension: blk
  license: LicenseRef-All-Rights-Reserved
  imports:
    - dagor_blk_data

seq:
  - id: type
    contents: [3]
    # no names expected
  - id: data
    type: dagor_blk_data
