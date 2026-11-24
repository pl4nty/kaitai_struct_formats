# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/alarm_clock_clothing.ksy
# Licence and copyright: see _community/README.md
meta:
  id: item_alarm_clock_clothing
  title: 'Project Zomboid save: alarm clock clothing inventory item'
  license: MIT
  imports:
    - item_clothing
    - item_alarm_clock
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4

# zombie.inventory.types.AlarmClockClothing.save / load
# Extends: Clothing (which extends InventoryItem)
# Note: Clothing itself has complex BitHeader serialization; AlarmClockClothing adds alarm fields after
seq:
  - id: clothing
    type: item_clothing(context, world_version)
  - id: alarm_clock
    type: item_alarm_clock(context, world_version)
