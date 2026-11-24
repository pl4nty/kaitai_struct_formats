# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/28_tree.ksy
meta:
  id: tree
  title: 'Project Zomboid save: tree object'
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
  - id: log_yield
    type: u1
  - id: damage_raw
    type: u1
instances:
  damage:
    value: damage_raw * 10
