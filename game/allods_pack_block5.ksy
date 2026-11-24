# Imported from https://github.com/SixShoot/AllodsUniversalUnpacker/blob/8a65b785a7a700b5dc651d94250dc90997f24f30/ksy/block5.ksy
meta: 
  id: allods_pack_block5
  title: Allods Online pack block type 5
  license: LicenseRef-All-Rights-Reserved
  endian: le
params:
  - id: size
    type: u4
seq:
  - id: entries
    type: u4
    repeat: expr
    repeat-expr: size
