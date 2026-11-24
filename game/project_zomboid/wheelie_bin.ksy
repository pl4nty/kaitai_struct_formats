# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/5_wheelie_bin.ksy
meta:
  id: wheelie_bin
  title: 'Project Zomboid save: wheelie bin object'
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
  - id: bin
    type: iso_object_shared::iso_pushable_object(context, world_version, 1)
