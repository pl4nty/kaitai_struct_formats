# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity/9_entity_script_info.ksy
# Licence and copyright: see _community/README.md
meta:
  id: entity_script_info
  title: 'Project Zomboid save: entity script info entity component'
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
  # zombie.entity.components.script.EntityScriptInfo.save/load
  - id: original_is_item
    type: u1
  - id: has_original
    type: u1
  - id: original_script
    type: common::string_utf
    if: has_original != 0
