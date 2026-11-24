# Imported from https://github.com/marehr/bam_bai_study/blob/b37b16702ba2d1e3a004c617a23d97e756493937/kaitai/bai.ksy
meta:
  id: bai
  title: BAM index (.bai)
  file-extension: bai
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents:
      - BAI
      - 0x01
  - id: n_ref
    type: u4
  - id: references
    type: reference
    repeat: expr
    repeat-expr: n_ref
  - id: n_no_coor
    type: u8
types:
  voffset:
    seq:
      - id: virtual_file_offset
        type: u8
    instances:
      coffset_bgzf_block_begin:
        value: virtual_file_offset >> 16
      uoffset_within_uncompressed_block:
        value: virtual_file_offset ^ (coffset_bgzf_block_begin << 16)
  chunk:
    seq:
      - id: chunk_beg
        size: 8
        type: voffset
      - id: chunk_end
        size: 8
        type: voffset
  bin:
    seq:
      - id: bin
        type: u4
      - id: n_chunk
        type: s4
      - id: chunks
        type: chunk
        repeat: expr
        repeat-expr: n_chunk
  reference:
    seq:
      - id: n_bin
        type: s4
      - id: bins
        type: bin
        repeat: expr
        repeat-expr: n_bin
      - id: n_intv
        type: s4
      - id: ioffset
        type: voffset
        repeat: expr
        repeat-expr: n_intv
  # Not used currently, bought here for completeness
  # pseudo_bin:
  #   seq:
  #     - id: bin
  #       type: u4
  #       contents: 37450
  #     - id: n_chunk
  #       type: s4
  #       contents: '2'
  #     - id: unmapped_beg
  #       type: voffset
  #       size: 8
  #     - id: unmapped_end
  #       type: voffset
  #       size: 8
  #     - id: n_mapped
  #       type: u8
  #     - id: n_unmapped
  #       type: u8
