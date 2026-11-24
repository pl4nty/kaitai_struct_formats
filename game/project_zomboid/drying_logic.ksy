# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity/16_drying_logic.ksy
meta:
  id: drying_logic
  title: 'Project Zomboid save: drying logic entity component'
  license: MIT
  imports:
    - common
    - entity_shared
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.entity.components.crafting.DryingLogic.load / save
  - id: header
    type: u2
  - id: drying_recipe_tag_query
    type: common::string_utf
    if: (header & 1) != 0
  - id: fuel_recipe_tag_query
    type: common::string_utf
    if: (header & 2) != 0
  - id: start_mode
    type: u1
    if: (header & 4) != 0
  - id: fuel_inputs_group_name
    type: common::string_utf
    if: (header & 8) != 0
  - id: fuel_outputs_group_name
    type: common::string_utf
    if: (header & 16) != 0
  - id: drying_inputs_group_name
    type: common::string_utf
    if: (header & 32) != 0
  - id: drying_outputs_group_name
    type: common::string_utf
    if: (header & 64) != 0
  - id: current_recipe
    type: current_recipe_block(context, world_version)
    if: (header & 128) != 0
types:
  current_recipe_block:
    params:
      - id: context
        type: any
      - id: world_version
        type: u4
    seq:
      - id: recipe_name
        type: common::string_utf
      - id: script_version
        type: u8
      - id: elapsed_time
        type: u4
      - id: craft_data
        type: entity_shared::craft_recipe_block(context, world_version)
