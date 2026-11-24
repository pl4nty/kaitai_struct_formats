# Imported from https://github.com/iconmaster5326/CrystalProjector/blob/79320b343d603aa069aa023fd54020d36419e082/schema/ksy/entities.ksy
# Licence and copyright: see _community/README.md
meta:
  id: crystal_project_entities
  title: Crystal Project chunk entities
  license: MIT
  imports:
    - /common/vlq_base128_le
  endian: le
doc: |
  A file of the form `yXe.dat`, that lists all entities in a 16x16x16 cube chunk,
  for the chunk at y level X.
seq:
  - id: version
    type: u1
    valid: 0
    doc: The current version is `0`.
  - id: num_entities
    type: u4
    doc: The number of entities in this chunk.
  - id: entities
    type: entity
    repeat: expr
    repeat-expr: num_entities
    doc: The entities in this chunk.
enums:
  entity_type:
    0: npc
    1: sign
    2: spark
    3: door
    4: home_point
    5: treasure
    6: crystal
    7: marker
  facing:
    0: xneg
    1: yneg
    2: zneg
    3: xpos
    4: ypos
    5: zpos
  sign_style:
    0: wooden
    100: bulletin_left
    101: bulletin_right
  door_style:
    0: boroboro
    1: cell
    2: stone
    3: wood
    4: red
    5: cell_cross
    6: boroboro_window
    7: red_window
    8: metal
    9: ornate
    10: sun_stone
    11: moon_stone
    12: paper
  treasure_type:
    0: nothing
    1: item
    2: equipment
    3: currency
  treasure_style:
    0: currency
    1: consumable
    2: artifact
    3: weapon
    4: armor
    5: accessory
  condition_type:
    0: always
    14: can_understand_quintar
    17: check_atlas
    7: check_crystal_count
    3: check_flag
    12: check_highest_member_level
    5: check_inventory
    15: check_npc_proximity
    4: check_number
    6: finished_moving
    23: garden
    32: is_ability_learned
    13: is_ability_unlocked
    18: is_demo
    34: is_facing
    28: is_game_cleared
    21: is_job_mastered
    11: is_job_present
    27: is_member_present
    33: is_passive_learned
    31: is_passive_unlocked
    30: is_patch_mode_active
    35: is_player_facing
    26: is_player_gender
    24: is_player_stranded
    16: is_riding_default_quintar
    8: is_riding_quintar
    20: is_riding_specific_mount
    9: lost_and_found_has_stock
    19: my_quintar
    1: never
    2: operation
    22: previous_battle_was_victory
    10: random
    29: randomizer
    25: skip_minigames
  shadow:
    0: none
    1: small
    2: normal
    3: home_point
    4: crystal
    5: large
  collision:
    0: none
    1: one_way_to
    2: one_way_from
    3: full
  physics:
    0: player_foot
    1: quintar_default
    2: salmon_default
    3: owl_default
    4: ibek_default
    5: salmon_rental
    6: salmon_royal
    7: quintar_rental
    8: quintar_desert
    9: salmon_lava
    10: quintar_float
    11: quintar_jump
    12: quintar_fly
    13: quintar_swim
    14: quintar_gold
    15: npc_foot
    16: npc_flying
    17: npc_salmon_fast
    18: npc_salmon_medium
    19: npc_salmon_slow
    20: npc_free
    21: npc_push_block
    22: npc_quintar_slow
    23: npc_quintar_medium
    24: npc_foot_water
    25: npc_salmon_medium_fast
    26: npc_quintar_desert
    27: npc_quintar_float
    28: npc_quintar_jump
    29: cinematic_slow
    30: cinematic_medium
    31: cinematic_fast
  jump:
    0: none
    1: up_voxel
    2: up_actor
    3: up_voxel_and_actor
    4: off_voxel
    5: up_voxel_off_voxel
    8: off_actor
    12: off_voxel_and_actor
    15: full
  wander:
    0: none
    1: circle_area
    2: route
    3: circle_perimeter
    4: square_perimeter
    5: line_x
    6: line_z
    7: square_area
  scope:
    0: private
    1: friend
    2: global
    3: temp
    4: friend_temp
    5: global_temp
  trigger:
    0: player_action
    1: player_proximity
    2: auto
    3: player_touch
    4: trigger_npc
  touch_type:
    0: stand_on
    1: xz_touch
    2: head_bonk
    3: any_contact
  trigger_context:
    0: sync
    1: async
    2: cinematic
  action:
    13: ability
    41: activity_countdown
    8: add_inventory
    16: add_number
    58: add_to_lost_and_found
    27: battle
    36: cancel_actions
    66: cancel_wander
    14: choice_message
    68: choice_message_anonymous
    18: command_npc
    78: comment
    3: condition
    22: context_switch
    57: credits
    23: do_narration
    62: face_away_from_player
    0: face_player
    35: future_actions
    71: garden
    69: hazard_burn
    15: inn
    55: insert_future_actions
    76: learn_ability
    77: learn_passive
    60: make_player_face_this
    1: message
    61: message_anonymous
    73: message_hint
    65: message_npc
    12: move
    45: move_away_from_player
    20: move_camera
    44: move_group
    46: move_group_to
    31: move_player
    53: move_player_instant
    34: move_player_to
    33: move_to
    17: multiply_number
    63: my_quintar
    72: new_game_plus
    54: particle
    38: play_music
    59: play_se_mine_ore
    49: play_se_switch_pressed
    50: play_se_switch_unpressed
    37: queue_future_actions
    52: refresh_bulletin
    30: refresh_lost_and_found
    43: refresh_npcs
    48: refresh_specific_npcs
    9: remove_inventory
    67: resume_wander
    21: revert_camera
    2: revert_facing
    40: revert_music
    24: set_facing
    6: set_flag
    70: set_last_safe_pos_to
    47: set_last_safe_pos_to_marker
    26: set_mount
    11: set_npc_property
    7: set_number
    25: set_player_facing
    56: set_player_facing_to_this
    5: shop
    28: shop_recipe
    29: shop_service
    39: stop_music
    10: stop_processing
    64: subtract_number
    51: teleport_player
    42: teleport_player_to
    19: trigger_npc
    32: unlock_ability
    74: unlock_job
    75: unlock_passive
    4: wait
  var_value_type:
    0: constant
    1: variable
    2: inventory
    3: random
  condition_operator:
    0: and
    1: or
    2: xor
    3: equiv
    4: impl
  move_wait_mode:
    0: none
    1: end
    2: exit
    4: collide
    6: exit_or_collide
  check_number_eval:
    0: less
    1: less_equal
    2: equal
    3: greater_equal
    4: greater
  atlas_type:
    0: inventory
    1: monster
    2: biome
    3: job
  atlas_state:
    0: hidden
    1: hinted
    2: seen
    3: acquired
    4: purchased
  quintar_condition_type:
    0: has_quintar_in_slot
    1: num_slots_occupied_at_least
    2: can_show_in_nursery
    3: has_egg_in_slot
    4: is_race_track_unlocked
    5: num_racers_owned_is_least
  quintar_action_type:
    0: send_home_egg
    1: manage_quintar
    2: mount_my_quintar
    3: unlock_race_track
    4: view_race_records
    5: record_race_result
  quintar_type:
    0: red
    1: blue
    2: yellow
    3: teal
    4: green
    5: black
    6: white
    7: gold
  quintar_nature:
    0: fiendish
    1: brutish
    2: woke
    3: fancy
    4: trusty
  quintar_track:
    0: beginner
    1: advanced
    2: expert
    3: race_4
    4: race_5
  shop_service_type:
    0: gender_change
    1: atlas_registrar
    2: growth_reallocation
    3: lost_and_found
    4: sadist
    5: rename
  garden_condition_type:
    0: is_planted
    1: is_sprouted
    2: player_has_seed
    3: garden_has_space
    4: can_water
  garden_action_type:
    0: plant_seed
    1: pluck
    2: watering_can
types:
  string:
    doc: A string.
    seq:
      - id: length
        type: vlq_base128_le
        doc: How long is this string?
      - id: value
        size: length.value
        type: str
        encoding: UTF-8
        doc: The string.
  nullable_string:
    doc: A boolean byte followed by a length-terminated string.
    seq:
      - id: has_value
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this string exist?
      - id: string
        type: string
        if: has_value == 1
        doc: The string, only if has_value is 1.
  entity:
    doc: An entity.
    seq:
      - id: id
        type: u4
        valid:
          min: 1
        doc: The entity ID. In the vanilla game, this goes from 1 to ~3000.
      - id: "x"
        type: s4
        doc: |
          The X position of the entity, in world coordinates (*NOT* chunk-offset
          coordinates!)
      - id: "y"
        type: s4
        doc: |
          The Y position of the entity, in world coordinates (*NOT* chunk-offset
          coordinates!)
      - id: "z"
        type: s4
        doc: |
          The Z position of the entity, in world coordinates (*NOT* chunk-offset
          coordinates!)
      - id: biome
        type: u1
        doc: |
          The biome ID where this entity should be considered to be located in. This is
          important for things like randomizer spoilers and bestiary listings.
      - id: type
        type: u1
        enum: entity_type
        valid:
          in-enum: true
        doc: The type of this entity.
      - id: comment
        type: nullable_string
        doc: A comment. Not displayed in game.
      - id: data
        type:
          switch-on: type
          cases:
            entity_type::npc: data_npc
            entity_type::sign: data_sign
            entity_type::spark: data_spark
            entity_type::door: data_door
            entity_type::home_point: data_home_point
            entity_type::treasure: data_treasure
            entity_type::crystal: data_crystal
            entity_type::marker: data_marker
        doc: Per-type entity data.
  data_npc:
    doc: Data for entities of type `npc`.
    seq:
      - id: key
        type: nullable_string
        doc: A name to refer to this entity from code.
      - id: linked_key
        type: nullable_string
        doc: An entity this entity is linked to.
      - id: tie_to_spawn
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this NPC despawn when its spawn point is out of range?
      - id: unique_per_key
        type: u1
        valid:
          any-of: [0, 1]
        doc: Will this NPC not spawn if there's already one with the same key?
      - id: num_outfits
        type: u4
        doc: The number of outfits this NPC has.
      - id: outfits
        type: npc_outfit
        repeat: expr
        repeat-expr: num_outfits
        doc: The outfits this NPC may have.
      - id: num_pages
        type: u4
        doc: The number of pages this NPC has.
      - id: pages
        type: npc_page
        repeat: expr
        repeat-expr: num_pages
        doc: The pages this NPC may have.
  npc_outfit:
    doc: The appearance, physics, and movement of an NPC.
    seq:
      - id: condition
        type: condition
        doc: The condition data for this outfit.
      - id: texture
        type: nullable_string
        doc: The string name of the texture file, if we're rendering as a sprite.
      - id: name
        type: nullable_string
        doc: The name of this outfit.
      - id: pc
        type: u1
        valid:
          any-of: [0, 1]
        doc: Are we a "fake PC"?
      - id: pc_level
        type: u1
        if: pc == 1
        doc: The level of the "fake PC".
      - id: pc_magic1
        size: 3
        if: pc == 1
        doc: Unknown.
      - id: facing
        type: u1
        enum: facing
        valid:
          in-enum: true
        doc: The direction this NPC initially faces.
      - id: shadow
        type: u1
        enum: shadow
        valid:
          in-enum: true
        doc: The type of shadows this NPC casts.
      - id: auto_step
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does the sprite automatically step?
      - id: has_voxel
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this NPC render as a voxel?
      - id: voxel
        type: u1
        if: has_voxel == 1
        doc: The voxel ID to render as.
      - id: magic4
        size: 1
        doc: Unknown.
      - id: player_collision
        type: u1
        enum: collision
        valid:
          in-enum: true
        doc: How this NPC collides with the player.
      - id: npc_collision
        type: u1
        enum: collision
        valid:
          in-enum: true
        doc: How this NPC collides with other NPCS.
      - id: physics
        type: u1
        enum: physics
        valid:
          in-enum: true
        doc: The physics this NPC uses to move.
      - id: jump
        type: u1
        enum: jump
        valid:
          in-enum: true
        doc: How this NPC jumps.
      - id: keep_spawned
        type: u1
        valid:
          any-of: [0, 1]
        doc: Keep this NPC spawned even when out of its spawn range?
      - id: wander
        type: u1
        enum: wander
        valid:
          in-enum: true
        doc: How this NPC wanders around.
      - id: wander_speed
        type: f4
        doc: How fast does this NPC move?
      - id: wander_frequency
        type: u4
        doc: How long does this NPC wait between points?
      - id: wander_radius
        type: f4
        doc: How large is the wandering area?
      - id: wander_is_route
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this a route?
      - id: num_wander_points
        type: u4
        if: wander_is_route == 1
        doc: The number of points in this wander route.
      - id: wander_points
        type: wander_route_point
        repeat: expr
        repeat-expr: num_wander_points
        if: wander_is_route == 1
        doc: The route this NPC wanders in.
      - id: wander_is_line
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this wander route a straight line?
  wander_route_point:
    doc: A point along a wander route.
    seq:
      - id: "x"
        type: s4
        doc: The X position.
      - id: "y"
        type: s4
        doc: The Y position.
      - id: "z"
        type: s4
        doc: The Z position.
      - id: speed
        type: f4
        doc: Movement speed.
      - id: wait
        type: u4
        doc: Wait time between points.
      - id: facing
        type: u1
        enum: facing
        valid:
          in-enum: true
        doc: Facing at end of point.
  condition:
    doc: A condition.
    seq:
      - id: type
        type: u4
        enum: condition_type
        valid:
          in-enum: true
        doc: The condition type.
      - id: inverted
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this condition inverted?
      - id: data
        type:
          switch-on: type
          cases:
            condition_type::check_atlas: condition_data_check_atlas
            condition_type::check_crystal_count: condition_data_check_crystal_count
            condition_type::check_flag: condition_data_check_var
            condition_type::check_highest_member_level: condition_data_check_highest_member_level
            condition_type::check_inventory: condition_data_check_inventory
            condition_type::check_npc_proximity: condition_data_check_npc_proximity
            condition_type::check_number: condition_data_check_var
            condition_type::garden: condition_data_garden
            condition_type::is_member_present: condition_data_is_member_present
            condition_type::is_player_gender: condition_data_id
            condition_type::is_job_mastered: condition_data_id
            condition_type::is_job_present: condition_data_id
            condition_type::is_riding_specific_mount: condition_data_is_riding_specific_mount
            condition_type::my_quintar: condition_data_my_quintar
            condition_type::operation: condition_data_operation
            condition_type::randomizer: condition_data_randomizer
            _: nothing
        doc: Condition data.
  nothing:
    doc: No data.
  condition_data_check_atlas:
    doc: Data associated with `condition::check_atlas`.
    seq:
      - id: type
        type: u1
        enum: atlas_type
        valid:
          in-enum: true
        doc: The type of records entry to check.
      - id: state
        type: u1
        enum: atlas_state
        valid:
          in-enum: true
        doc: The state of the records entry to check.
      - id: biome_id
        type: u1
        doc: The ID of the biome to check.
      - id: other_id
        type: u4
        doc: The ID of the item/monster/job to check.
      - id: magic1
        size: 8
        doc: Unknown.
  condition_data_check_crystal_count:
    doc: Data associated with `condition::check_crystal_count`.
    seq:
      - id: magic1
        size: 5
        doc: Unknown.
      - id: count
        type: u4
        doc: The number of crystals you need to pass the condition.
      - id: magic2
        size: 1
        doc: Unknown.
  condition_data_check_highest_member_level:
    doc: Data associated with `condition::check_highest_member_level`.
    seq:
      - id: magic1
        size: 5
        doc: Unknown.
      - id: level
        type: u4
        doc: The level to check.
      - id: magic2
        size: 1
        doc: Unknown.
  condition_data_check_inventory:
    doc: Data associated with `condition::check_inventory`.
    seq:
      - id: type
        type: u1
        enum: treasure_type
        valid:
          in-enum: true
        doc: The item type to give.
      - id: item
        type: u4
        doc: The item/equipment ID to give. (TODO - what if currency?)
      - id: count
        type: u4
        doc: The amount of the item to give. (TODO - what if currency?)
      - id: randomized
        type: u1
        valid:
          any-of: [0, 1]
        doc: Randomize this item?
  condition_data_check_npc_proximity:
    doc: Data associated with `condition::check_npc_proximity`.
    seq:
      - id: magic1
        size: 1
        doc: Unknown.
      - id: key
        type: nullable_string
        doc: The NPC key to check.
      - id: magic2
        size: 4
        doc: Unknown.
      - id: distance
        type: u4
        doc: The distance to check.
      - id: magic3
        size: 7
        doc: Unknown.
  condition_data_check_var:
    doc: |
      Condition data for `condition_type::check_flag` and
      `condition_type::check_number`.
    seq:
      - id: scope
        type: u1
        enum: scope
        valid:
          in-enum: true
        doc: The scope of the flag to check.
      - id: friend_key
        type: nullable_string
        doc: |
          for `scope::friend`/`scope::friend_temp`, the key of the NPC whose variable you
          are accessing.
      - id: variable
        type: nullable_string
        doc: The number/flag to test.
      - id: eval
        type: u1
        enum: check_number_eval
        valid:
          in-enum: true
        doc: The comparion operator, for `check_number` conditions.
      - id: value
        type: var_value
        doc: The value to check the variable for.
  condition_data_is_member_present:
    doc:  Condition data for `condition_type::is_member_present`.
    seq:
      - id: magic1
        size: 6
        doc: Unknown.
      - id: slot
        type: u1
        doc: The slot to check for a party member.
      - id: magic2
        size: 10
        doc: Unknown.
  condition_data_id:
    doc: Condition data for any condition that tests a single ID.
    seq:
      - id: magic1
        size: 3
        doc: Unknown.
      - id: gender
        type: u1
        doc: The ID of the gender to test.
      - id: magic2
        size: 2
        doc: Unknown.
      - id: job
        type: u4
        doc: The ID of the job to test.
      - id: magic3
        size: 7
        doc: Unknown.
  condition_data_garden:
    doc: Condition data for `condition_type::garden`.
    seq:
      - id: type
        type: u1
        enum: garden_condition_type
        valid:
          in-enum: true
        doc: The garden-related operation we're checking.
      - id: slot
        type: u4
        doc: The garden slot, used for some of the garden operations.
  condition_data_my_quintar:
    doc: Condition data for `condition_type::my_quintar`.
    seq:
      - id: type
        type: u1
        enum: quintar_condition_type
        valid:
          in-enum: true
        doc: The quintar-related operation we're checking.
      - id: slot
        type: u4
        doc: The quintar slot, used for some of the quintar operations.
      - id: value
        type: u4
        doc: A value used for some of the quintar operations.
      - id: track
        type: u1
        doc: A Quintar racetrack, used for some of the quintar operations.
  condition_data_is_riding_specific_mount:
    doc: Condition data for `condition_type::is_riding_specific_mount`.
    seq:
      - id: magic1
        size: 6
        doc: Unknown.
      - id: mount
        type: u1
        enum: physics
        valid:
          in-enum: true
        doc: Which physics type do we want check if the player is right now?
      - id: magic2
        size: 10
        doc: Unknown.
  condition_data_operation:
    doc: Condition data for `condition_type::operation`.
    seq:
      - id: lhs
        type: condition
        doc: The left-hand condition.
      - id: magic1
        size: 1
        doc: Unknown.
      - id: rhs
        type: condition
        doc: The left-hand condition.
  condition_data_randomizer:
    doc: Condition data for `condition_type::randomizer`.
    seq:
      - id: crystals
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this condition true if we're randomizing crystals?
      - id: monsters
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this condition true if we're randomizing monsters?
      - id: bosses
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this condition true if we're randomizing bosses?
      - id: items
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this condition true if we're randomizing items?
      - id: recovery
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this condition true if we're randomizing recovery items?
      - id: progression
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this condition true if we're randomizing progression items?
      - id: gated
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this condition true if we're in gated progression mode?
      - id: has_invalid_item
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we have an invalid item?
      - id: invalid_item
        type: u4
        if: has_invalid_item == 1
        doc: An item ID to be treated as invalid.
  npc_page:
    doc: The behavior code of an NPC.
    seq:
      - id: condition
        type: condition
        doc: The condition for this page to be active.
      - id: trigger
        type: u1
        enum: trigger
        valid:
          in-enum: true
        doc: The method of triggering this page's code.
      - id: trigger_data
        type:
          switch-on: trigger
          cases:
            trigger::player_proximity: trigger_data_player_proximity
            trigger::player_touch: trigger_data_player_touch
            _: trigger_data_none
        doc: The data associated with the specific trigger.
      - id: actions
        type: npc_actions_list
        doc: The actions executed.
      - id: context
        type: u1
        enum: trigger_context
        valid:
          in-enum: true
        doc: The context of the actions.
  trigger_data_player_proximity:
    doc: The data for a NPC page with a trigger of `trigger::player_proximity`.
    seq:
      - id: radius
        type: f4
        doc: The trigger radius.
      - id: min_x
        type: f4
        doc: The smaller X bound.
      - id: min_y
        type: f4
        doc: The smaller Y bound.
      - id: min_z
        type: f4
        doc: The smaller Z bound.
      - id: max_x
        type: f4
        doc: The larger X bound.
      - id: max_y
        type: f4
        doc: The larger Y bound.
      - id: max_z
        type: f4
        doc: The larger Z bound.
      - id: magic2
        size: 2
        doc: Unknown.
  trigger_data_player_touch:
    doc: The data for a NPC page with a trigger of `trigger::player_touch`.
    seq:
      - id: magic1
        size: 29
        doc: Unknown.
      - id: type
        type: u1
        enum: touch_type
        valid:
          in-enum: true
        doc: The type of touch that triggers this page.
  trigger_data_none:
    doc: The data for a trigger with no data. Just empty bytes.
    seq:
      - id: magic1
        size: 30
        doc: Unknown.
  npc_actions_list:
    doc: A list of actions.
    seq:
      - id: num_actions
        type: u4
        doc: The number of actions in this page.
      - id: actions
        type: npc_action
        repeat: expr
        repeat-expr: num_actions
        doc: The actions that occur when the trigger is met.
  npc_action:
    doc: An action execute by an NPC.
    seq:
      - id: type
        type: u4
        enum: action
        valid:
          in-enum: true
        doc: The type of action performed.
      - id: data
        type:
          switch-on: type
          cases:
            action::add_inventory: action_data_inventory
            action::add_to_lost_and_found: action_data_inventory
            action::context_switch: action_data_context_switch
            action::choice_message: action_data_message
            action::choice_message_anonymous: action_data_message
            action::add_number: action_data_modify_var
            action::battle: action_data_battle
            action::cancel_actions: action_data_modify_action_queue
            action::command_npc: action_data_command_npc
            action::condition: action_data_condition
            action::do_narration: action_data_do_narration
            action::future_actions: action_data_future_actions
            action::garden: action_data_garden
            action::inn: action_data_message
            action::insert_future_actions: action_data_modify_action_queue
            action::message_hint: action_data_message_hint
            action::message_npc: action_data_message_npc
            action::message: action_data_message
            action::message_anonymous: action_data_message
            action::move: action_data_move
            action::move_camera: action_data_move_camera
            action::move_group: action_data_move
            action::move_group_to: action_data_move
            action::move_player: action_data_move
            action::move_player_instant: action_data_move
            action::move_player_to: action_data_move
            action::move_to: action_data_move
            action::my_quintar: action_data_my_quintar
            action::particle: action_data_particle
            action::play_music: action_data_play_music
            action::queue_future_actions: action_data_modify_action_queue
            action::refresh_npcs: action_data_refresh
            action::refresh_specific_npcs: action_data_refresh
            action::remove_inventory: action_data_inventory
            action::revert_camera: action_data_move_camera
            action::revert_music: action_data_play_music
            action::set_facing: action_data_set_facing
            action::set_flag: action_data_modify_var
            action::set_last_safe_pos_to: action_data_move
            action::set_last_safe_pos_to_marker: action_data_set_last_safe_pos_to_marker
            action::set_npc_property: action_data_set_npc_property
            action::set_number: action_data_modify_var
            action::set_mount: action_data_set_mount
            action::set_player_facing: action_data_set_facing
            action::subtract_number: action_data_modify_var
            action::shop: action_data_shop
            action::shop_recipe: action_data_shop
            action::shop_service: action_data_shop_service
            action::stop_processing: action_data_refresh
            action::stop_music: action_data_play_music
            action::teleport_player: action_data_move
            action::teleport_player_to: action_data_move
            action::trigger_npc: action_data_trigger_npc
            action::unlock_ability: action_data_unlock_ability
            action::wait: action_data_wait
            _: nothing
        doc: Any data assocated with the action.
  action_data_inventory:
    doc: Data associated with `action::add_inventory` and `action::remove_inventory`.
    seq:
      - id: type
        type: u1
        enum: treasure_type
        valid:
          in-enum: true
        doc: The item type to give.
      - id: item
        type: u4
        doc: The item/equipment ID to give. (TODO - what if currency?)
      - id: count
        type: u4
        doc: The amount of the item to give. (TODO - what if currency?)
      - id: randomized
        type: u1
        valid:
          any-of: [0, 1]
        doc: Randomize this item?
  action_data_modify_action_queue:
    doc: |
      Data associated with `action::cancel_actions` and
      `action::queue_future_actions`.
    seq:
      - id: magic1
        size: 1
        doc: Unknown.
      - id: key
        type: nullable_string
        doc: The NPC key to cancel the actions of.
      - id: magic2
        size: 14
        doc: Unknown.
  action_data_battle:
    doc: Data associated with `action::battle`.
    seq:
      - id: troop
        type: u4
        doc: The ID of the troop to fight.
      - id: training
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this a training battle, where you can lose without consequence?
      - id: var
        type: nullable_string
        doc: The variable to set based on member count.
      - id: override_biome
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we override what arena the fight takes place in?
      - id: biome
        type: u4
        if: override_biome == 1
        doc: The biome ID to override the arena.
      - id: override_indoors
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we override if this fight is indoors or not?
      - id: indoors
        type: u1
        valid:
          any-of: [0, 1]
        if: override_indoors == 1
        doc: Is this fight indoors or not?
      - id: no_loot
        type: u1
        valid:
          any-of: [0, 1]
        doc: Can you not loot/steal from this fight?
  action_data_context_switch:
    doc: Data associated with `action::context_switch`.
    seq:
      - id: context
        type: u1
        enum: trigger_context
        valid:
          in-enum: true
        doc: The new context for this page to become.
  action_data_command_npc:
    doc: Data associated with `action::command_npc`.
    seq:
      - id: key
        type: nullable_string
        doc: The NPC key to command.
      - id: num_commands
        type: u4
        doc: The number of commands to have the keyed NPC execute.
      - id: commands
        type: npc_action
        repeat: expr
        repeat-expr: num_commands
        doc: The commands to have the keyed NPC execute.
  action_data_garden:
    doc: Action data for `action::garden`.
    seq:
      - id: type
        type: u1
        enum: garden_action_type
        valid:
          in-enum: true
        doc: The garden-related operation we're doing.
      - id: slot
        type: u4
        doc: The garden slot, used for some of the garden operations.
  action_data_message:
    doc: |
      Data associated with `action::message`, `action::choice_message`, and
      `action::inn`.
    seq:
      - id: message
        type: nullable_string
        doc: The message to display.
      - id: magic1
        size: 1
        doc: Unknown.
      - id: has_choices
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we have choices? Used only in `action::choice_message`.
      - id: num_choices
        type: u4
        if: has_choices == 1
        doc: |
          The number of choices the player can select from. Used only in
          `action::choice_message`.
      - id: choices
        type: choice_message_choice
        repeat: expr
        repeat-expr: num_choices
        if: has_choices == 1
        doc: The choices the player can select from. Used only in `action::choice_message`.
      - id: answer_var
        type: nullable_string
        doc: The variable to place the choice in. Used only in `action::choice_message`.
      - id: magic2
        size: 1
        doc: Unknown.
  choice_message_choice:
    doc: A dialogue choice in a `action::choice_message`.
    seq:
      - id: text
        type: nullable_string
        doc: The text displayed to the user.
      - id: magic1
        size: 4
        doc: Unknown.
      - id: item_cost
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this cost an item to select?
      - id: default
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this the default option?
      - id: cancel
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this option back out of the dialogue?
      - id: condition
        type: condition
        doc: The condition under which you may select the choice.
  action_data_condition:
    doc: Data associated with `action::condition`.
    seq:
      - id: condition
        type: condition
        doc: The condition to branch based upon.
      - id: actions_true
        type: npc_actions_list
        doc: The actions executed if true.
      - id: actions_false
        type: npc_actions_list
        doc: The actions executed if false.
  action_data_do_narration:
    doc: Data associated with `action::do_narration`.
    seq:
      - id: id
        type: u1
        doc: The ID of the narration to play.
  action_data_future_actions:
    doc: Data associated with `action::future_actions`.
    seq:
      - id: frames
        type: u4
        doc: The number of frames to wait before executing `actions`.
      - id: show_timer
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this show a timer?
      - id: dismount
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this force a dismount when the timer runs out?
      - id: teleport
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this a teleport?
      - id: hazard
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this a hazard?
      - id: context
        type: u1
        enum: trigger_context
        valid:
          in-enum: true
        doc: The context to execute `actions` in.
      - id: num_actions
        type: u4
        doc: The number of actions to execute.
      - id: actions
        type: npc_action
        repeat: expr
        repeat-expr: num_actions
        doc: The actions to execute.
  action_data_message_hint:
    doc: Data associated with `action::message_hint`.
    seq:
      - id: has_item
        type: u1
        valid:
          any-of: [0, 1]
        doc: Are we hinting at the location of an item?
      - id: item
        type: u4
        if: has_item == 1
        doc: The item to hint at.
      - id: has_job
        type: u1
        valid:
          any-of: [0, 1]
        doc: Are we hinting at the location of a job?
      - id: job
        type: u4
        if: has_job == 1
        doc: The job to hint at.
  action_data_message_npc:
    doc: Data associated with `action::message_npc`.
    seq:
      - id: message
        type: nullable_string
        doc: The message to display.
      - id: key
        type: nullable_string
        doc: The key of the NPC to have display this message.
      - id: magic1
        size: 7
        doc: Unknown.
  action_data_move:
    doc: |
      Data associated with `action::move`, `action::move_group`,
      `action::move_player`, `action::teleport_player`, and the `_to` forms of such.
    seq:
      - id: "x"
        type: s4
        doc: The X offset to move.
      - id: "y"
        type: s4
        doc: The Y offset to move.
      - id: "z"
        type: s4
        doc: The Z offset to move.
      - id: has_facing
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we change our facing when moving?
      - id: facing
        type: u1
        enum: facing
        valid:
          in-enum: true
        if: has_facing == 1
        doc: The facing we change to while moving.
      - id: magic1
        size: 1
        doc: Unknown.
      - id: marker
        type: nullable_string
        doc: The key of a marker to move to, if using `action::move_to` and friends.
      - id: speed
        type: f4
        doc: How fast we move.
      - id: wait
        type: u1
        enum: move_wait_mode
        valid:
          in-enum: true
        doc: Our waiting mode.
      - id: no_collision
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we not collide with anything?
      - id: has_jump
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we change our jump type when moving?
      - id: jump
        type: u1
        enum: jump
        valid:
          in-enum: true
        if: has_jump == 1
        doc: The jump type we change to while moving.
      - id: magic2
        size: 1
        doc: Unknown.
  action_data_move_camera:
    doc: Data associated with `action::move_camera` and `action::revert_camera`.
    seq:
      - id: "x"
        type: s4
        doc: The X offset to move. Unused in `action::revert_camera`.
      - id: "y"
        type: s4
        doc: The Y offset to move. Unused in `action::revert_camera`.
      - id: "z"
        type: s4
        doc: The Z offset to move. Unused in `action::revert_camera`.
      - id: magic1
        size: 2
        doc: Unknown.
      - id: frames
        type: f4
        doc: How many frames this movement should occur over.
      - id: magic2
        size: 1
        doc: Unknown.
  action_data_my_quintar:
    doc: Data associated with `action::my_quintar`.
    seq:
      - id: action_type
        type: u1
        enum: quintar_action_type
        valid:
          in-enum: true
        doc: The type of quintar-related operation you're performing.
      - id: type
        type: u1
        enum: quintar_type
        valid:
          in-enum: true
        doc: The type of quintar to give, for `quintar_action_type::send_home_egg`.
      - id: nature
        type: u1
        enum: quintar_nature
        valid:
          in-enum: true
        doc: The nature of quintar to give, for `quintar_action_type::send_home_egg`.
      - id: slot
        type: u4
        doc: The slot to put the egg in, for `quintar_action_type::send_home_egg`.
      - id: track
        type: u1
        enum: quintar_track
        valid:
          in-enum: true
        doc: The track to unlock, for the track-related actions.
  action_data_particle:
    doc: Data associated with `action::particle`.
    seq:
      - id: id
        type: u4
        doc: The ID of the particle effect to display.
      - id: "x"
        type: s4
        doc: The X offset to display the effect.
      - id: "y"
        type: s4
        doc: The Y offset to display the effect.
      - id: "z"
        type: s4
        doc: The Z offset to display the effect.
  action_data_play_music:
    doc: |
      Data associated with `action::play_music` (and
      `action::revert_music`/`action::stop_music`, where all fields are unused).
    seq:
      - id: track
        type: u1
        doc: The music to play.
      - id: no_fade
        type: u1
        valid:
          any-of: [0, 1]
        doc: Cut to the music instead of fading it in?
      - id: loop
        type: u1
        valid:
          any-of: [0, 1]
        doc: Loop this music?
      - id: apply_to_battle
        type: u1
        valid:
          any-of: [0, 1]
        doc: Use this music in battle too?
      - id: except_victory
        type: u1
        valid:
          any-of: [0, 1]
        doc: When `apply_to_battle` is 1, do we keep the normal victory music?
  action_data_set_facing:
    doc: Data associated with `action::set_facing`.
    seq:
      - id: facing
        type: u1
        enum: facing
        valid:
          in-enum: true
        doc: The facing to set.
  action_data_set_last_safe_pos_to_marker:
    doc: Data associated with `action::set_last_safe_pos_to_marker`.
    seq:
      - id: key
        type: nullable_string
        doc: The marker key to use.
  action_data_set_npc_property:
    doc: Data associated with `action::set_npc_property`.
    seq:
      - id: change_collides_player
        type: u1
        valid:
          any-of: [0, 1]
        doc: Change if we collide with the player or not?
      - id: collides_player
        type: u1
        valid:
          any-of: [0, 1]
        if: change_collides_player == 1
        doc: The collision with the player.
      - id: change_collides_npcs
        type: u1
        valid:
          any-of: [0, 1]
        doc: Change if we collide with other NPCs or not?
      - id: collides_npcs
        type: u1
        valid:
          any-of: [0, 1]
        if: change_collides_npcs == 1
        doc: The collision with other NPCs.
      - id: change_jump
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we change our jump type?
      - id: jump
        type: u1
        enum: jump
        valid:
          in-enum: true
        if: change_jump == 1
        doc: The jump type we change to.
      - id: change_keep_spawned
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we change `keep_spawned`?
      - id: keep_spawned
        type: u1
        valid:
          any-of: [0, 1]
        if: change_keep_spawned == 1
        doc: Change if we keep spawned or not.
      - id: change_auto_step
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we change `auto_step`?
      - id: auto_step
        type: u1
        valid:
          any-of: [0, 1]
        if: change_auto_step == 1
        doc: Change if we auto-step or not.
  action_data_modify_var:
    doc: |
      Data associated with `action::set_flag`, `action::set_number`, and
      `action::add_number`.
    seq:
      - id: scope
        type: u1
        enum: scope
        valid:
          in-enum: true
        doc: The variable's scope.
      - id: friend_key
        type: nullable_string
        doc: |
          for `scope::friend`/`scope::friend_temp`, the key of the NPC whose variable you
          are accessing.
      - id: variable
        type: nullable_string
        doc: The variable to set.
      - id: value
        type: var_value
        doc: The value to set/add/etc. the variable with.
  var_value:
    doc: A variable value, to add or test with.
    seq:
      - id: setting_mode
        type: u1
        enum: var_value_type
        valid:
          in-enum: true
        doc: Is this a constant, another variable, or so on?
      - id: bool_value
        type: u1
        valid:
          any-of: [0, 1]
        doc: |
          The value to set/test/etc. a flag to, if we're setting a flag via
          `var_value_type::constant`.
      - id: int_value
        type: u4
        doc: |
          The value to set/add/test/etc. a number to, if we're setting a number via
          `var_value_type::constant`.
      - id: scope
        type: u1
        enum: scope
        valid:
          in-enum: true
        doc: The scope of the variable, if we're `var_value_type::variable`.
      - id: variable
        type: nullable_string
        doc: The variable, if we're `var_value_type::variable`.
      - id: magic1
        size: 5
        doc: Unknown.
  action_data_set_mount:
    doc: Data associated with `action::set_mount`.
    seq:
      - id: magic1
        size: 1
        doc: Unknown.
      - id: mount
        type: u1
        enum: physics
        valid:
          in-enum: true
        doc: The mount type, which is keyed by its physics type.
      - id: disable_set_home_point
        type: u1
        valid:
          any-of: [0, 1]
        doc: Whether or not this mount disables setting of home points.
      - id: disable_set_safe_coord
        type: u1
        valid:
          any-of: [0, 1]
        doc: Whether or not this mount disables setting of safe points.
      - id: plays_sounds
        type: u1
        valid:
          any-of: [0, 1]
        doc: Whether or not this mount plays sounds
  action_data_shop:
    doc: Data associated with `action::shop` and `action::shop_recipe`.
    seq:
      - id: num_shop_items
        type: u4
        doc: How many items are sold at this shop.
      - id: shop_items
        type: shop_item
        repeat: expr
        repeat-expr: num_shop_items
        doc: The items sold at this shop.
  shop_item:
    doc: A single shop item in the data for a `action::shop` or `action::shop_recipe`.
    seq:
      - id: type
        type: u1
        enum: treasure_type
        valid:
          in-enum: true
        doc: |
          The type of item sold here.
          In `action::shop`, only `treasure_type::item` and `treasure_type::equipment` are
          valid here.
          In `action::shop_recipe`s, anything goes.
      - id: item
        type: u4
        doc: The ID of an item/equipment/recipe.
      - id: cost_percent
        type: u4
        doc: |
          A number indicating how much more or less this item should cost than the price
          listed in its database entry. Default is 100.
      - id: condition
        type: condition
        doc: A condition under which the item is sold.
  action_data_shop_service:
    doc: Data associated with `action::shop_service`.
    seq:
      - id: service
        type: u1
        enum: shop_service_type
        valid:
          in-enum: true
        doc: The service this shop provides.
      - id: magic1
        size: 4
        doc: Unknown.
  action_data_refresh:
    doc: |
      Data associated with `action::stop_processing`, `action::refresh_npcs`, and
      `action::refresh_specific_npcs`.
    seq:
      - id: refresh_outfit
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we refresh the outfit? Unused in `action::refresh_npcs`.
      - id: refresh_page
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we refresh the page? Unused in `action::refresh_npcs`.
      - id: refresh_position
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we refresh the position? Unused in `action::refresh_npcs`.
      - id: cancel_all_actions
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we cancel ongoing actions? Unused in `action::refresh_npcs`.
      - id: trigger_player_action
        type: u1
        valid:
          any-of: [0, 1]
        doc: |
          Do we trigger `trigger_type::player_action` pages? Unused in
          `action::refresh_npcs`.
      - id: trigger_player_proximity
        type: u1
        valid:
          any-of: [0, 1]
        doc: |
          Do we trigger `trigger_type::player_proximity` pages? Unused in
          `action::refresh_npcs`.
      - id: trigger_auto
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we trigger `trigger_type::auto` pages? Unused in `action::refresh_npcs`.
      - id: trigger_player_touch
        type: u1
        valid:
          any-of: [0, 1]
        doc: |
          Do we trigger `trigger_type::player_touch` pages? Unused in
          `action::refresh_npcs`.
      - id: trigger_trigger_npc
        type: u1
        valid:
          any-of: [0, 1]
        doc: |
          Do we trigger `trigger_type::trigger_npc` pages? Unused in
          `action::refresh_npcs`.
      - id: global_refresh_outfits
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we refresh all NPC outfits? Unused in `action::refresh_specific_npcs`.
      - id: global_refresh_pages
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we refresh all NPC pages? Unused in `action::refresh_specific_npcs`.
      - id: global_refresh_positions
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we refresh all NPC positions? Unused in `action::refresh_specific_npcs`.
      - id: global_try_spawn
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we refresh all NPC spawning? Unused in `action::refresh_specific_npcs`.
      - id: global_try_despawn
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we refresh all NPC despawning? Unused in `action::refresh_specific_npcs`.
      - id: key
        type: nullable_string
        doc: The NPC key to refresh. Used only in `action::refresh_specific_npcs`.
  action_data_trigger_npc:
    doc: Data associated with `action::trigger_npc`.
    seq:
      - id: key
        type: nullable_string
        doc: The key of the NPC to trigger.
      - id: type
        type: u1
        enum: trigger
        valid:
          in-enum: true
        doc: The trigger type to invoke.
  action_data_unlock_ability:
    doc: Data associated with `action::unlock_ability`.
    seq:
      - id: no_randomize
        type: u1
        valid:
          any-of: [0, 1]
        doc: Can the randomizer not shuffle this ability around?
      - id: ability
        type: u4
        doc: The ability ID to unlock.
  action_data_wait:
    doc: Data associated with `action::wait`.
    seq:
      - id: frames
        type: u4
        doc: The number of frames to wait.
  data_sign:
    doc: Data for entities of type `sign`.
    seq:
      - id: title
        type: nullable_string
        doc: The sign's title.
      - id: message
        type: nullable_string
        doc: The sign's message.
      - id: facing
        type: u1
        enum: facing
        valid:
          in-enum: true
        doc: The direction the sign is facing in.
      - id: style
        type: u1
        enum: sign_style
        valid:
          in-enum: true
        doc: The 3D rendering method of the sign.
  data_spark:
    doc: Data for entities of type `spark`.
    seq:
      - id: behaviour
        type: u4
        doc: The ID of spark behaviour object.
      - id: is_unique
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this spark not respawn after you encounter it?
      - id: is_giant
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this spark a boss?
      - id: victory_flag
        type: nullable_string
        doc: The global flag set on victory with this spark.
      - id: victory_flag_true
        type: u1
        valid:
          any-of: [0, 1]
        doc: Unknown. `Global Flag On Victory Is True` in Crystal Edit.
      - id: victory_flag_temp
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this flag set on victory of `global_temp` scope?
      - id: victory_flag_unset_on_spawn
        type: u1
        valid:
          any-of: [0, 1]
        doc: Do we unset this flag when this spark spawns?
      - id: trigger
        type: nullable_string
        doc: The NPC key to trigger on victory.
      - id: num_troops
        type: u4
        doc: The number of troop entries.
      - id: troops
        type: possible_troop
        repeat: expr
        repeat-expr: num_troops
        doc: The possible troop spawns.
  possible_troop:
    doc: |
      An entry in the troop table of spark entities. Represents a possible troop
      result when colliding with the spark.
    seq:
      - id: id
        type: u4
        doc: The ID of the troop.
      - id: weight
        type: u4
        doc: The chance of this troop being selected for battle. Determines RNG weights.
      - id: invert
        type: u1
        valid:
          any-of: [0, 1]
        doc: Invert the conditions?
      - id: has_min_diff
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this troop only spawn under a certain difficulty?
      - id: min_diff
        type: u4
        if: has_min_diff == 1
        doc: The ID of a difficulty that this troop only spawns in.
  data_door:
    doc: Data for entities of type `door`.
    seq:
      - id: style
        type: u1
        enum: door_style
        valid:
          in-enum: true
        doc: The 3D rendering method of the door.
      - id: locked
        type: u1
        valid:
          any-of: [0, 1]
        doc: Is this door locked?
      - id: has_key
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this door have a key?
      - id: key
        type: u4
        if: has_key == 1
        doc: The item ID of the key that can unlock this door.
      - id: flag
        type: nullable_string
        doc: The global flag set when this door is unlocked.
      - id: invert_flag
        type: u1
        valid:
          any-of: [0, 1]
        doc: Invert the global flag?
  data_home_point:
    doc: Data for entities of type `home_point`.
    seq:
      - id: name
        type: nullable_string
        doc: The name of the save point.
  data_treasure:
    doc: Data for entities of type `treasure`.
    seq:
      - id: facing
        type: u1
        enum: facing
        valid:
          in-enum: true
        doc: The direction the chest is facing.
      - id: type
        type: u1
        enum: treasure_type
        valid:
          in-enum: true
        doc: The type of thing inside this chest.
      - id: contents
        type: u4
        doc: |
          The contents of this chest. An item/equipment ID, or the amount of currency,
          depending on `type`.
      - id: has_style_override
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this chest have a style override?
      - id: style_override
        type: u1
        enum: treasure_style
        valid:
          in-enum: true
        if: has_style_override == 1
        doc: Overrides the color of the chest.
  data_crystal:
    doc: Data for entities of type `crystal`.
    seq:
      - id: magic1
        type: u1
        valid: 1
        doc: Unknown. Seemingly always a 1.
      - id: job
        type: u4
        doc: The ID of the job you get at this crystal.
      - id: r
        type: u1
        doc: The color of the crystal. Red channel.
      - id: g
        type: u1
        doc: The color of the crystal. Green channel.
      - id: b
        type: u1
        doc: The color of the crystal. Blue channel.
      - id: offset_half_x
        type: u1
        valid:
          any-of: [0, 1]
        doc: Offset this crystal half a block on the X axis?
      - id: offset_half_z
        type: u1
        valid:
          any-of: [0, 1]
        doc: Offset this crystal half a block on the Z axis?
  data_marker:
    doc: Data for entities of type `marker`.
    seq:
      - id: key
        type: nullable_string
        doc: The flag that's set when this marker is reached.
      - id: proximity
        type: f4
        doc: How close you have to be to trigger this marker.
