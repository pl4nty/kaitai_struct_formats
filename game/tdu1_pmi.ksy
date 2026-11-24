# Imported from https://github.com/djey47/tduf-next/blob/707ff9f7742067e989cb231e66e6524c6475fbbe/doc/RE/TDU1-pmi/tdu1-pmi.ksy
meta:
  id: tdu1_pmi
  file-extension: pmi
  license: MIT
  endian: le

seq:
  - id: unk0
    size: 8
  - id: size_file
    type: u4
  - id: magic
    size: 4
    type: strz
    encoding: ASCII
  - id: moba_tag
    size: 4
    type: strz
    encoding: ASCII
  - id: unk1
    contents: [0,0,3,0]
  - id: size_without_header
    type: u4
  - id: size_moba
    type: u4
  - id: asset_count
    type: u4
  - id: height_maybe
    type: f4
  - id: height2_maybe
    type: f4
  - id: gap1
    size: 4
    contents: [0xcd, 0xcd, 0xcd, 0xcd]
  - id: unk2
    size: size_moba - 36
  - id: gap2
    size: 4
    contents: [0xcd, 0xcd, 0xcd, 0xcd]
  - id: assets
    type: asset_list

types:
  entity: # 32 bytes
    seq:
      - id: pos_x
        size: 2
      - id: pos_y
        size: 2
      - id: pos_z
        size: 2
      - id: scale_x
        size: 2 
      - id: scale_y
        size: 2
      - id: scale_z
        size: 2
      - id: rot_x
        size: 2
      - id: rot_y
        size: 2
      - id: rot_z
        size: 2
      - id: unk_x
        size: 2
      - id: unk_y
        size: 2
      - id: unk_z
        size: 2
      - id: display_group
        size: 4
        type: strz
        encoding: ASCII
      - id: zeroes
        contents: [0,0,0,0]

  entity_alt: # 128 bytes TODO
    seq:
      - id: unk
        size: 128
        
  asset:
    seq:
      - id: magic_mob
        size: 8
        type: strz
        encoding: ASCII
      - id: size1_bytes
        type: u4
      - id: size2_bytes
        type: u4
      - id: entity_name
        size: 8
        type: strz
        encoding: ASCII
      - id: entity_count
        type: u2
      - id: entity_type
        type: u2
      - id: unk6
        size: 4
        # contents: [2,0,2,95]
      - id: entities
        type: entity_list
        
  entity_list:
    seq:
      - id: entity_list
        type:
          switch-on: _parent.entity_type
          cases:
            0: entity
            85: entity_alt
        repeat: expr
        repeat-expr: _parent.entity_count
            
  
  asset_list:
    seq:
      - id: asset
        type: asset
        repeat: expr
        repeat-expr: _parent.asset_count
    
