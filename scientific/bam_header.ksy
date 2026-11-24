# Imported from https://github.com/marehr/bam_bai_study/blob/b37b16702ba2d1e3a004c617a23d97e756493937/kaitai/bam_header.ksy
meta:
  id: bam_header
  file-extension: bam_header
  license: LicenseRef-All-Rights-Reserved
  endian: le
  
seq:
  - id: header
    type: header
  - id: reference_sequences
    type: reference_sequence
    repeat: expr
    repeat-expr: header.n_ref

types:
  header:
    seq:
      - id: magic
        contents: ["BAM", 1]
      - id: l_text
        type: s4
      - id: text
        size: l_text
        type: str
        encoding: UTF-8
      - id: n_ref
        type: s4
  reference_sequence:
    seq:
      - id: l_name
        type: s4
      - id: name
        size: l_name
        type: str
        encoding: UTF-8
      - id: l_ref
        type: s4
