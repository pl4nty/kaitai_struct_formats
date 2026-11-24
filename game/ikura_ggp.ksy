# Imported from https://github.com/mnakamura1337/engine_ikura/blob/17feacdcb2b20f47e155ad6df6b70cd9bc867550/ikura_ggp.ksy
meta:
  id: ikura_ggp
  file-extension: ggp
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents: GGPFAIKE
  - id: bit_depth
    type: u4
  - id: xor_key
    size: 8
    process: xor([71, 71, 80, 70, 65, 73, 75, 69]) # = "GGPFAIKE"
  - id: ofs_img
    type: u4
  - id: len_img
    type: u4
  - id: ofs_regions
    type: u4
  - id: len_regions
    type: u4
instances:
  img:
    pos: ofs_img
    size: len_img
    process: xor(xor_key)
  regions:
    pos: ofs_regions
    size: len_regions
