# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/radio.ksy
# Licence and copyright: see _community/README.md
meta:
  id: item_radio
  title: 'Project Zomboid save: radio inventory item'
  license: MIT
  imports:
    - common
    - item_moveable
    - iso_object_shared
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4

# zombie.inventory.types.Radio.save / load
# Extends: Moveable (which extends InventoryItem)
seq:
  - id: moveable_data
    type: item_moveable(context, world_version)
  - id: has_device_data
    type: u1
  - id: device_data
    type: iso_object_shared::device_data
    if: has_device_data != 0
