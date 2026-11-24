# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/20_broken_glass.ksy
meta:
  id: broken_glass
  title: 'Project Zomboid save: broken glass object'
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
  # IsoBrokenGlass.load only calls super.load, no additional fields
  []
