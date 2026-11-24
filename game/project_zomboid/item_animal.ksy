# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/animal.ksy
# Licence and copyright: see _community/README.md
meta:
  id: item_animal
  title: 'Project Zomboid save: animal inventory item'
  license: MIT
  imports:
    - common
    - animal
  endian: be

# zombie.inventory.types.AnimalInventoryItem.save / load
# Extends: InventoryItem
# Note: delegates to IsoAnimal serialization
params:
  - id: context
    type: any
  - id: world_version
    type: u4

seq:
  - id: animal_data
    type: animal::animal(context, world_version)
