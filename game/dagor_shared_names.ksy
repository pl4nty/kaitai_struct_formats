# Imported from https://github.com/kotiq/blk/blob/636f1d94ca4f7aaad0f29a76d3dfbbde3f9eef9c/src/formats/game/dagor_shared_names.ksy
meta:
  id: dagor_shared_names
  title: DagorEngine shared names
  license: LicenseRef-All-Rights-Reserved
  endian: le


seq:
  - id: hash
    type: u8
  - id: dict_stem
    size: 32
  - id: names_zstd
    size-eos: True
