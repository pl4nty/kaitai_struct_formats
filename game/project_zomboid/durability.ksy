# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity/21_durability.ksy
# Licence and copyright: see _community/README.md
meta:
  id: durability
  title: 'Project Zomboid save: durability entity component'
  license: MIT
  imports:
    - common
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.entity.components.combat.Durability.save/load (BitHeader Short)
  - id: flags
    type: u2
  - id: current_hit_points
    type: f4
    if: (flags & 1) != 0
  - id: max_hit_points
    type: f4
    if: (flags & 2) != 0
  - id: material
    type: common::string_utf
    if: (flags & 4) != 0
