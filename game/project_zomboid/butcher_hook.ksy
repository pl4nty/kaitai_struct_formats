# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/40_butcher_hook.ksy
meta:
  id: butcher_hook
  title: 'Project Zomboid save: butcher hook object'
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
  # IsoButcherHook.load only calls super.load
  # No additional fields are read
  []
