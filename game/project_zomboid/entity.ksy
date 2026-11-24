# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity.ksy
meta:
  id: entity
  title: 'Project Zomboid save: game entity'
  license: MIT
  imports:
    - common

    # component types
    - attribute_container
    - fluid_container
    - sprite_config
    - lua_component
    - parts
    - signals
    - entity_script_info
    - ui_config
    - craft_logic
    - furnace_logic
    - test_component
    - mashing_logic
    - drying_logic
    - meta_tag_component
    - resources
    - craft_bench
    - craft_recipe_component
    - durability
    - drying_craft_logic
    - context_menu_config
    - sprite_overlay_config
    - craft_bench_sounds
    - wall_covering_config
  endian: be
types:
  # zombie.entity.GameEntity.saveEntity / loadEntity
  game_entity:
    params:
      - id: context
        type: any
      - id: world_version
        type: u4
    seq:
      - id: num_components
        type: u1
      - id: components
        type: entity_component(context, world_version)
        repeat: expr
        repeat-expr: num_components

  entity_component:
    params:
      - id: context
        type: any
      - id: world_version
        type: u4
    seq:
      - id: block_len
        type: u4
      - id: component_id
        type: u2
      - id: data
        size: block_len - 2
        type: component(context, world_version, component_id)

  component:
    params:
      - id: context
        type: any
      - id: world_version
        type: u4
      - id: component_id
        type: u2
    seq:
      - id: component_data
        type:
          switch-on: component_id
          cases:
            0: common::unknown(0)
            1: attribute_container(context, world_version)
            2: fluid_container(context, world_version)
            3: sprite_config(context, world_version)
            6: lua_component(context, world_version)
            7: parts(context, world_version)
            8: signals(context, world_version)
            9: entity_script_info(context, world_version)
            11: ui_config(context, world_version)
            12: craft_logic(context, world_version)
            13: furnace_logic(context, world_version)
            14: test_component(context, world_version)
            15: mashing_logic(context, world_version)
            16: drying_logic(context, world_version)
            17: meta_tag_component(context, world_version)
            18: resources(context, world_version)
            19: craft_bench(context, world_version)
            20: craft_recipe_component(context, world_version)
            21: durability(context, world_version)
            22: drying_craft_logic(context, world_version)
            23: context_menu_config(context, world_version)
            24: sprite_overlay_config(context, world_version)
            25: craft_bench_sounds(context, world_version)
            26: wall_covering_config(context, world_version)
            _: common::unknown(component_id.as<u4>)
        doc: |-
          Dynamic zombie.entity.Component, the type is determined by:
              ComponentType zombie.entity.ComponentType.FromId(short id)
          Each type is registered in zombie.entity.ComponentType enum definition
