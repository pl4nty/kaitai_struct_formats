# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/container.ksy
# Licence and copyright: see _community/README.md
meta:
  id: item_container
  title: 'Project Zomboid save: container inventory item'
  license: MIT
  imports:
    - common
    - inventory
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4

# zombie.inventory.types.InventoryContainer.save / load
# Extends: InventoryItem
seq:
  - id: container_id
    type: s4
  - id: weight_reduction
    type: s4
  - id: container_items
    type: inventory::container(context, world_version)
