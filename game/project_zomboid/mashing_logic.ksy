# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity/15_mashing_logic.ksy
meta:
  id: mashing_logic
  title: 'Project Zomboid save: mashing logic entity component'
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
  # zombie.entity.components.crafting.MashingLogic.load / save
  - id: header
    type: u1
  - id: recipe_tag_query
    type: common::string_utf
    if: (header & 1) != 0
  - id: inputs_group_name
    type: common::string_utf
    if: (header & 2) != 0
  - id: resource_fluid_id
    type: common::string_utf
    if: (header & 4) != 0
  - id: current_recipe
    type: current_recipe_block(context, world_version)
    if: (header & 8) != 0
  - id: barrel_consumed_amount
    type: f4
    if: (header & 16) != 0
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
        type: f8
      - id: last_world_age
        type: f8
      - id: craft_data
        type: entity_shared::craft_recipe_block(context, world_version)
