# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/12_barbecue.ksy
# Licence and copyright: see _community/README.md
meta:
  id: barbecue
  title: 'Project Zomboid save: barbecue object'
  license: MIT
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  - id: has_propane_tank
    type: u1
  - id: fuel_amount_minutes
    type: s4
  - id: lit
    type: u1
  - id: last_update_time
    type: f4
  - id: minutes_since_extinguished
    type: s4
  - id: has_normal_sprite
    type: u1
  - id: normal_sprite_id
    type: s4
    if: has_normal_sprite == 1
  - id: has_no_tank_sprite
    type: u1
  - id: no_tank_sprite_id
    type: s4
    if: has_no_tank_sprite == 1
