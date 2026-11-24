# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/21_car_battery_charger.ksy
# Licence and copyright: see _community/README.md
meta:
  id: car_battery_charger
  title: 'Project Zomboid save: car battery charger object'
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
  - id: debug
    type: u1
seq:
  - id: has_item
    type: u1
  - id: item
    type: inventory::sized_blob(context, world_version)
    if: has_item == 1
  - id: has_battery
    type: u1
  - id: battery
    type: inventory::sized_blob(context, world_version)
    if: has_battery == 1
  - id: activated
    type: u1
  - id: last_update
    type: f4
  - id: charge_rate
    type: f4
