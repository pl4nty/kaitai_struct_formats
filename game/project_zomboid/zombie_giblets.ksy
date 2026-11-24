# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/30_zombie_giblets.ksy
# Licence and copyright: see _community/README.md
meta:
  id: zombie_giblets
  title: 'Project Zomboid save: zombie giblets'
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
  # IsoZombieGiblets.Serialize() returns false
  # This class should never be serialized to world files
  # Keeping this as empty for completeness
  []
