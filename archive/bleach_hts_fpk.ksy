# Imported from https://github.com/remixer-dec/GameTranslationPipelines/blob/b145e6972ee8ae8ed121c0ea64ffa49fbf71a189/PSP/Bleach%20Heat%20The%20Soul%20series/structs/fpk.ksy
meta:
  id: bleach_hts_fpk
  title: Bleach Heat The Soul (1-7) .fpk container
  file-extension: fpk
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: idk
    type: u4
  - id: itemcount
    type: u4
  - id: idk_always16
    type: u4
  - id: bundle_size
    type: u4
  - id: files
    size: 48
    type: file_ref
    repeat: expr
    repeat-expr: itemcount

types:
  file_ref:
    seq:
      - id: path
        type: str
        terminator: 0
        consume: false
        encoding: Shift_JIS
      - id: padding
        size: 48 - _io.pos - 12
        type: zeros
      - id: start_offset
        type: u4
      - id: compressed_size
        type: u4
      - id: uncompressed_size
        type: u4
    instances:
      content:
        io: _root._io
        pos: start_offset
        size: compressed_size
        doc: |
          compressed lz77-like data, if compressed_size == uncompressed_size treat as
          uncompressed

  zeros:
    seq:
      - id: zerobytes
        type: u1
        repeat: eos
