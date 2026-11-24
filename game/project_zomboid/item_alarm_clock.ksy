# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/alarm_clock.ksy
meta:
  id: item_alarm_clock
  title: 'Project Zomboid save: alarm clock inventory item'
  license: MIT
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4

# zombie.inventory.types.AlarmClock.save / load
# Extends: InventoryItem
seq:
  - id: alarm_hour
    type: s4
  - id: alarm_minutes
    type: s4
  - id: alarm_set
    type: u1
  - id: ring_since
    type: f4
  - id: force_dont_ring
    type: s4
    if: world_version >= 205
