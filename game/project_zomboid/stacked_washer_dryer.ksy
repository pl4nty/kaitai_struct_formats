# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/35_stacked_washer_dryer.ksy
meta:
  id: stacked_washer_dryer
  title: 'Project Zomboid save: stacked washer-dryer object'
  license: MIT
  imports:
    - iso_object_shared
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  - id: washer
    type: iso_object_shared::clothing_washer
  - id: dryer
    type: iso_object_shared::clothing_dryer
