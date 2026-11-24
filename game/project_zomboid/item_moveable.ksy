# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/moveable.ksy
meta:
  id: item_moveable
  title: 'Project Zomboid save: moveable inventory item'
  license: MIT
  imports:
    - common
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4

# zombie.inventory.types.Moveable.save / load
# Extends: InventoryItem
seq:
  - id: world_sprite
    type: common::string_utf
  - id: is_light
    type: u1
  - id: light_use_battery
    type: u1
    if: is_light != 0
  - id: light_has_battery
    type: u1
    if: is_light != 0
  - id: has_light_bulb_item
    type: u1
    if: is_light != 0
  - id: light_bulb_item
    type: common::string_utf
    if: (is_light != 0) and (has_light_bulb_item != 0)
  - id: light_power
    type: f4
    if: is_light != 0
  - id: light_delta
    type: f4
    if: is_light != 0
  - id: light_r
    type: f4
    if: is_light != 0
  - id: light_g
    type: f4
    if: is_light != 0
  - id: light_b
    type: f4
    if: is_light != 0
