# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/literature.ksy
meta:
  id: item_literature
  title: 'Project Zomboid save: literature inventory item'
  license: MIT
  imports:
    - common
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4

# zombie.inventory.types.Literature.save / load
# Extends: InventoryItem
# NOTE: BitHeader short for 226+, byte for < 226
seq:
  - id: flags
    type:
      switch-on: world_version >= 226
      cases:
        true: u2
        false: u1
  - id: num_pages
    type:
      switch-on: num_page_type
      cases:
        0: s1
        1: s2
        2: s4
    if: (flags & 1) != 0
  - id: already_read
    type:
      switch-on: num_page_type
      cases:
        0: s1
        1: s2
        2: s4
    if: (flags & 8) != 0
  - id: num_custom_pages
    type: s4
    if: (flags & 32) != 0
  - id: custom_pages
    type: common::string_utf
    repeat: expr
    repeat-expr: num_custom_pages
    if: (flags & 32) != 0
  - id: locked_by
    type: common::string_utf
    if: (flags & 64) != 0
  - id: num_learned_recipes
    type: s2
    if: (world_version >= 226) and (flags & 128) != 0
  - id: learned_recipes
    type: common::string_utf
    repeat: expr
    repeat-expr: num_learned_recipes
    if: (world_version >= 226) and (flags & 128) != 0
instances:
  num_page_type:
    value: '(flags & 1) == 0 ? 0 : ((flags & 2) != 0 ? 1 : ((flags & 4) != 0 ? 2 : 0))'
  can_be_read:
    value: '(flags & 1) != 0 and (flags & 16) != 0'
