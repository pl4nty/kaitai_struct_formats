# Imported from https://github.com/Thell/bdo-housecraft/blob/3af0b47113c4709afab148ae2d3fa83748e08ac6/data/houseinfo/formats/houseinfo.ksy
meta:
  id: bdo_houseinfo
  file-extension: bss
  license: Unlicense
  endian: le

seq:
  - id: header
    size: 4
    type: str
    encoding: UTF-8

  - id: num_entries
    type: u4

  - id: house_info
    type: houseinfo_type
    repeat: expr
    repeat-expr: num_entries

types:
  craft_list_type:
    seq:
      - id: item_craft_index
        type: u4

      - id: house_level
        type: u4

  houseinfo_type:
    seq:
      - id: need_explore_point
        type: u2

      - id: affiliated_town
        type: u2

      - id: parent_node
        type: u2

      - id: unk1
        type: u2

      - id: character_key
        type: u2

      - id: unk2
        type: u2

      - id: house_group
        type: u4

      - id: house_floor
        type: u4

      - id: len_need_house_key
        type: u8

      - id: need_house_key
        type: u2
        repeat: expr
        repeat-expr: len_need_house_key

      - id: num_craft_list_items
        type: u4

      - id: craft_list
        type: craft_list_type
        repeat: expr
        repeat-expr: num_craft_list_items

      - id: pad1
        type: u1
