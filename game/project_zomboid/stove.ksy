# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/16_stove.ksy
meta:
  id: stove
  title: 'Project Zomboid save: stove object'
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
  - id: activated
    type: u1
  - id: seconds_timer
    type: s4
  - id: max_temperature
    type: f4
  - id: first_turn_on
    type: u1
  - id: broken
    type: u1
