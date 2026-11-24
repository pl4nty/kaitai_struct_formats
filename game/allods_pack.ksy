# Imported from https://github.com/SixShoot/AllodsUniversalUnpacker/blob/8a65b785a7a700b5dc651d94250dc90997f24f30/ksy/pack.ksy
meta:
  id: allods_pack
  title: Allods Online pack archive
  license: LicenseRef-All-Rights-Reserved
  imports:
    - allods_pack_block0
    - allods_pack_block1
    - allods_pack_block2
    - allods_pack_block4
    - allods_pack_block5
    - allods_pack_block6
  endian: le
seq:
  - id: data
    size-eos: true
    type: allods_pack
    process: zlib
types:
  pack:
    seq:
      - id: block0_id
        contents: [ 0x00, 0x00, 0x00, 0x00 ]
      - id: block0
        type: allods_pack_block0
      - id: block1_id
        contents: [ 0x01, 0x00, 0x00, 0x00 ]
      - id: block1_length
        type: u4
      - id: block1
        size: block1_length
        type: allods_pack_block1
      - id: block2_id
        contents: [ 0x02, 0x00, 0x00, 0x00 ]
      - id: block2_length
        type: u4
      - id: block2
        size: block2_length
        type: allods_pack_block2
      - id: block3_id
        contents: [ 0x03, 0x00, 0x00, 0x00 ]
      - id: block3_length
        type: u4
      - id: block3
        size: block3_length
      - id: block4_id
        contents: [ 0x04, 0x00, 0x00, 0x00 ]
      - id: block4_length
        type: u4
      - id: block4
        size: block4_length * 8
        type: allods_pack_block4(block4_length)
      - id: block5_id
        contents: [ 0x05, 0x00, 0x00, 0x00 ]
      - id: block5_length
        type: u4
      - id: block5
        size: block5_length * 4
        type: allods_pack_block5(block5_length)
      - id: block6_id
        contents: [ 0x06, 0x00, 0x00, 0x00 ]
      - id: block6_length # number of dirs
        type: u4
      - id: block6
        type: allods_pack_block6(block6_length)
