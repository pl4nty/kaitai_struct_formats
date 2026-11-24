# Imported from https://github.com/SixShoot/AllodsUniversalUnpacker/blob/8a65b785a7a700b5dc651d94250dc90997f24f30/ksy/block1.ksy
meta:
  id: allods_pack_block1
  title: Allods Online pack block type 1
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: offset #not sure
    type: u4
  - id: count
    type: u4
  - id: entries
    type: entry(_io.pos)
    repeat: expr
    repeat-expr: count
types:
  entry:
    params:
      - id: start
        type: u4
    seq:
      - id: offset
        type: u4
      - id: length
        type: u4
      - id: index #TODO: id
        type: u4
    instances:
      value:
        pos: offset + start
        size: length
        type: str
        terminator: 0
        encoding: UTF-8
