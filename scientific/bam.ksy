# Imported from https://github.com/marehr/bam_bai_study/blob/b37b16702ba2d1e3a004c617a23d97e756493937/kaitai/bam.ksy
# based on https://delagoya.github.io/rusty-bio/binary-file-parsing-in-bioinformatics

meta:
  id: bam
  file-extension: bam
  license: LicenseRef-All-Rights-Reserved
  imports:
    - bam_alignment
    - bam_header
  endian: le
seq:
  - id: header
    type: bam_header
  - id: alignments
    type: bam_alignment
    repeat: eos
