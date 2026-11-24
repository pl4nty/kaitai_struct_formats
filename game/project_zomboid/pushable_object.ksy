# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/4_pushable_object.ksy
meta:
  id: pushable_object
  title: 'Project Zomboid save: pushable object'
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
  - id: pushable_object
    type: iso_object_shared::iso_pushable_object(context, world_version, 0)
