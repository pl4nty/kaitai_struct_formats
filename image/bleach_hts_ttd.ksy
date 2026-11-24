# Imported from https://github.com/remixer-dec/GameTranslationPipelines/blob/b145e6972ee8ae8ed121c0ea64ffa49fbf71a189/PSP/Bleach%20Heat%20The%20Soul%20series/structs/ttd.ksy
meta:
  id: bleach_hts_ttd
  title: Bleach Heat The Soul 7 .ttd texture data container
  file-extension: ttd
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: itemcount
    type: u4
  - id: unk1
    size: 12
  - id: files
    type: file_chunk
    repeat: expr
    repeat-expr: itemcount

#
types:
  file_chunk:
    seq:
      - id: header
        size: 64 + 16
        type: file_ref
      - id: data
        size: header.data_size
  file_ref:
    seq:
      - id: data_size
        type: u8
      - id: filler
        type: u8
      - id: name
        type: str
        terminator: 0
        encoding: Shift_JIS
      - id: extension
        type: str
        terminator: 0
        encoding: Shift_JIS
      - id: path
        type: str
        terminator: 0
        encoding: Shift_JIS
      - id: padding
        type: zeros

  zeros:
    seq:
      - id: zerobytes
        type: u1
        repeat: eos
