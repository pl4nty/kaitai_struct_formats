# Imported from https://github.com/kotiq/blk/blob/636f1d94ca4f7aaad0f29a76d3dfbbde3f9eef9c/src/formats/game/data.ksy
meta:
  id: dagor_blk_data
  title: Dagor Engine BLK data block
  license: LicenseRef-All-Rights-Reserved
  imports:
    - dagor_blk_names
    - dagor_blk_content

seq:
  - id: names
    type: dagor_blk_names
  - id: content
    type: dagor_blk_content
