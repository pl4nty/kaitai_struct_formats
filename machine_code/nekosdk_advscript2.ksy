# Imported from https://github.com/Inori/FuckGalEngine/blob/c966c2bf82975d078beb3b9c0b53f7390d3618d9/NekoSDK/nekosdk_advscript2.ksy
meta:
  id: nekosdk_advscript2
  title: NekoSDK ADV script v2
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents: ["NEKOSDK_ADVSCRIPT2", 0]
  - id: nodes_qty
    type: u4
  - id: nodes
    type: node
    repeat: expr
    repeat-expr: nodes_qty
types:
  nekostr:
    seq:
      - id: len
        type: u4
      - id: value
        size: len
        type: str
        encoding: Shift_JIS
  node:
    seq:
      - id: id
        type: u4
      - id: type1
        type: u4
      - id: some_ofs
        type: u4
      - id: opcode
        type: u4
      - id: spacer1
        size: 0x80
      - id: next_id
        type: u4
      - id: spacer2
        size: 0x40
      - id: strs
        type: nekostr
        repeat: expr
        repeat-expr: 33
