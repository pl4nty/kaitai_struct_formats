# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/24_mannequin.ksy
# Licence and copyright: see _community/README.md
meta:
  id: mannequin
  title: 'Project Zomboid save: mannequin object'
  license: MIT
  imports:
    - common
    - inventory
    - visual
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  - id: dir_index
    type: u1
  - id: init
    type: u1
  - id: female
    type: u1
  - id: zombie
    type: u1
  - id: skeleton
    type: u1
  - id: mannequin_script_name
    type: common::string_utf
  - id: pose
    type: common::string_utf
  - id: human_visual
    type: visual::human_visual
  - id: has_container
    type: u1
  - id: container_id
    type: s4
    if: has_container == 1
  - id: container
    type: inventory::container(context, world_version)
    if: has_container == 1
  - id: num_worn_items
    type: u1
    if: has_container == 1
  - id: worn_items
    type: worn_item_entry
    repeat: expr
    repeat-expr: num_worn_items
    if: has_container == 1
types:
  worn_item_entry:
    seq:
      - id: body_location
        type: common::string_utf
      - id: item_index
        type: s2
