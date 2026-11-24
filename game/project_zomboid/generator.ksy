# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/22_generator.ksy
meta:
  id: generator
  title: 'Project Zomboid save: generator object'
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
  - id: connected
    type: u1
  - id: activated
    type: u1
  - id: raw_fuel
    type: f4
  - id: condition
    type: s4
  - id: last_hour
    type: s4
instances:
  fuel:
    value: 'raw_fuel > 10.0 ? 10.0 : raw_fuel'
