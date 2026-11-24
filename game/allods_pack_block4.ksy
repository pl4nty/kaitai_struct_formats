# Imported from https://github.com/SixShoot/AllodsUniversalUnpacker/blob/8a65b785a7a700b5dc651d94250dc90997f24f30/ksy/block4.ksy
meta:
  id: allods_pack_block4
  title: Allods Online pack block type 4
  license: LicenseRef-All-Rights-Reserved
  endian: le
params:
  - id: size
    type: u4
seq:
  - id: entries
    type: block4_entry
    repeat: expr
    repeat-expr: size
types:
  block4_entry:
    seq:
      - id: u4_1
        type: u4
      - id: u4_2
        type: u4
