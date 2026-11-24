# Imported from https://github.com/marehr/bam_bai_study/blob/b37b16702ba2d1e3a004c617a23d97e756493937/kaitai/bgzf.ksy
meta:
  id: bgzf
  title: BGZF blocked gzip file
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: blocks
    type: block
    repeat: eos
types:
  block:
    seq:
      - id: id1
        contents: [31]
      - id: id2
        contents: [139]
      - id: cm
        contents: [8]
      - id: flg
        contents: [4]
      - id: mtime
        type: u4
      - id: xfl
        type: u1
      - id: os
        type: u1
      - id: xlen
        type: u2
      - id: extra_subfields
        size: xlen
        type: extra_subfields
      - id: cdata
        size: extra_subfields.bsize - xlen - 19
        # process: zlib
      - id: crc32
        type: u4
      - id: isize
        type: u4
  extra_subfields:
    seq:
      - id: si1
        contents: [66]
      - id: si2
        contents: [67]
      - id: slen
        contents: [2, 0]
      - id: bsize
        type: u2
