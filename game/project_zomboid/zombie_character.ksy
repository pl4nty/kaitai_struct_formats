# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/3_zombie.ksy
# Licence and copyright: see _community/README.md
meta:
  id: zombie_character
  title: 'Project Zomboid save: zombie character'
  license: MIT
  imports:
    - character_shared
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1

seq:
  - id: loaded_file_version
    type: s4
  - id: time_since_seen_flesh
    type: s4
  - id: state_flags
    type: s4
  - id: num_worn_items
    type: u1
  - id: worn_items
    type: character_shared::worn_item_entry
    repeat: expr
    repeat-expr: num_worn_items
