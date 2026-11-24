# Imported from https://github.com/SixShoot/AllodsUniversalUnpacker/blob/8a65b785a7a700b5dc651d94250dc90997f24f30/ksy/block6.ksy
meta:
  id: allods_pack_block6
  title: Allods Online pack block type 6
  license: LicenseRef-All-Rights-Reserved
  endian: le
params:
  - id: size
    type: u4
seq:
  - id: entries
    type: block6_entry
    repeat: expr
    repeat-expr: size
types:
  block6_entry:
    seq:
      - id: length
        type: u4
      - id: magic
        contents: [ 0x2E, 0x00, 0x2E, 0x00]
      - id: value
        size: length - 4
        type: str
        encoding: UTF-16LE
