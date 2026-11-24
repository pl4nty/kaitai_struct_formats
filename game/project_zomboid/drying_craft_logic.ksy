# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity/22_drying_craft_logic.ksy
meta:
  id: drying_craft_logic
  title: 'Project Zomboid save: drying craft logic entity component'
  license: MIT
  imports:
    - common
    - entity_shared
    - craft_logic
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # Extends CraftLogic, then appends wetness table
  - id: craft_logic
    type: craft_logic(context, world_version)
  - id: num_wetnesses
    type: u4
  - id: wetnesses
    type: f8
    repeat: expr
    repeat-expr: num_wetnesses
    if: num_wetnesses == craft_logic.in_progress.num_entries
