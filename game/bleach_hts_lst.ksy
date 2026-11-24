# Imported from https://github.com/remixer-dec/GameTranslationPipelines/blob/b145e6972ee8ae8ed121c0ea64ffa49fbf71a189/PSP/Bleach%20Heat%20The%20Soul%20series/structs/lst.ksy
meta:
  id: bleach_hts_lst
  title: Bleach Heat The Soul 7 filename list .lst (sector.lst)
  file-extension: lst
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents: 'UFLC'
  - id: filename_block_size
    type: u4
  - id: unk
    type: u4be
  - id: files
    type: chunk_ref
    repeat: eos
types:
  chunk_ref:
    seq:
      - id: filename
        size: _parent.filename_block_size
        type: str
        terminator: 0
        encoding: ASCII
      - id: sector_offset
        type: u4
      - id: file_size
        type: u4
  raw_block:
    seq:
      - id: unknown_section_skipper
        size: 16
    instances:
      final_bytes:
        pos: _io.pos
        type: u8
