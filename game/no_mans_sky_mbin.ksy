# Imported from https://gist.githubusercontent.com/encounter/106f91bd0e6293cbd0228f7e3e93b79b/raw/d7060e41f9a975d61cb89c4f54f72eebd8fdf375/mbin.ksy
meta:
  id: no_mans_sky_mbin
  title: "No Man's Sky MBIN"
  file-extension: mbin
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: le

seq:
  - id: header
    type: mbin_header
  - id: table
    type:
      switch-on: header.template_name
      cases:
        '"cGcProductTable"': list(_io.pos, "product_entry")
        '"cGcRecipeTable"':  list(_io.pos, "refiner_recipe")
        '"cGcSubstanceTable"':  list(_io.pos, "substance_entry")
        '"cGcTechnologyTable"': list(_io.pos, "technology_entry")
        '"cTkLocalisationTable"': list(_io.pos, "localization_entry")
        _: unknown

types:
  unknown: {}

  mbin_header:
    seq:
      - id: magic
        contents: [0xCC, 0xCC, 0xCC, 0xCC]
      - id: version
        type: u4
      - id: timestamp
        type: u8
      - id: template_guid
        type: u8
      - id: template_name
        size: 64
        type: strz
      - id: padding
        type: u8

  list_def:
    seq:
      - id: rel_offset
        type: u8
      - id: size
        type: u4
      - contents: [0x01, 0xAA, 0xAA, 0xAA]

  list:
    params:
      - id: pos
        type: u8
      - id: list_type
        type: str
    seq:
      - id: info
        type: list_def
    instances:
      values:
        io: _root._io
        pos: pos + info.rel_offset
        type:
          switch-on: list_type
          cases:
            '"localization_entry"': localization_entry
            '"product_entry"': product_entry
            '"refiner_recipe"': refiner_recipe
            '"refiner_recipe_element"': refiner_recipe_element
            '"stats_bonus"': stats_bonus
            '"substance_entry"': substance_entry
            '"technology_entry"': technology_entry
            '"technology_requirement"': technology_requirement
            _: unknown
        repeat: expr
        repeat-expr: info.size

  v_string:
    params:
      - id: pos
        type: u8
    seq:
      - id: info
        type: list_def
    instances:
      value:
        io: _root._io
        pos: pos + info.rel_offset
        size: info.size
        type: strz

  str_list_0x10:
    params:
      - id: pos
        type: u8
    seq:
      - id: info
        type: list_def
    instances:
      values:
        io: _root._io
        pos: pos + info.rel_offset
        size: 16
        type: strz
        repeat: expr
        repeat-expr: info.size

  localization_entry:
    seq:
      - id: id
        size: 32
        type: strz
      - id: english
        type: v_string(_io.pos)
      - id: french
        type: v_string(_io.pos)
      - id: italian
        type: v_string(_io.pos)
      - id: german
        type: v_string(_io.pos)
      - id: spanish
        type: v_string(_io.pos)
      - id: russian
        type: v_string(_io.pos)
      - id: polish
        type: v_string(_io.pos)
      - id: dutch
        type: v_string(_io.pos)
      - id: portuguese
        type: v_string(_io.pos)
      - id: latin_american_spanish
        type: v_string(_io.pos)
      - id: brazilian_portuguese
        type: v_string(_io.pos)
      - id: simplified_chinese
        type: v_string(_io.pos)
      - id: traditional_chinese
        type: v_string(_io.pos)
      - id: tencent_chinese
        type: v_string(_io.pos)
      - id: korean
        type: v_string(_io.pos)
      - id: japanese
        type: v_string(_io.pos)
      - id: us_english
        type: v_string(_io.pos)

  technology_entry:
    seq:
      - id: id
        size: 16
        type: strz
      - id: group
        size: 32
        type: strz
      - id: name
        size: 128
        type: strz
      - id: lower_name
        size: 128
        type: strz
      - id: subtitle
        type: v_string(_io.pos)
      - id: description
        type: v_string(_io.pos)
      - id: teach
        type: u8
        enum: boolean
      - id: hint_start
        size: 32
        type: strz
      - id: hint_end
        size: 32
        type: strz
      - id: icon
        type: filename_ref
      - size: 4
      - id: color
        type: color
      - id: level
        type: u4
      - id: chargeable
        type: u4
        enum: boolean
      - id: charge_amount
        type: u4
      - id: charge_type
        type: u4
        enum: substance_category
      - id: charge_by
        type: str_list_0x10(_io.pos)
      - id: charge_multiplier
        type: f4
      - id: build_fully_carged
        type: u1
        enum: boolean
      - id: uses_ammo
        type: u1
        enum: boolean
      - size: 2
      - id: ammo_id
        size: 16
        type: strz
      - id: primary_item
        type: u1
        enum: boolean
      - id: upgrade
        type: u1
        enum: boolean
      - id: core
        type: u1
        enum: boolean
      - id: repair_tech
        type: u1
        enum: boolean
      - id: procedural
        type: u1
        enum: boolean
      - size: 3
      - id: category
        type: u4
        enum: technology_category
      - id: rarity
        type: u4
        enum: technology_rarity
      - id: value
        type: f4
      - size: 4
      - id: requirements
        type: list(_io.pos, "technology_requirement")
      - id: base_stat
        type: u4
        enum: stats_type
      - size: 4
      - id: stat_bonuses
        type: list(_io.pos, "stats_bonus")
      - id: required_tech
        size: 16
        type: strz
      - id: required_level
        type: u4
      - size: 4
      - id: focus_locator
        size: 32
        type: strz
      - id: upgrade_color
        type: color
      - id: link_color
        type: color
      - id: reward_group
        size: 16
        type: strz
      - id: base_value
        type: u4
      - id: cost
        type: item_price_modifiers
      - id: required_rank
        type: u4
      - id: dispensing_race
        type: u4
        enum: alien_race
      - id: fragment_cost
        type: u4
      - id: tech_shop_rarity
        type: u4
        enum: technology_rarity
      - id: wiki_enabled
        type: u8
        enum: boolean
      - id: damaged_description
        type: v_string(_io.pos)

  product_entry:
    seq:
      - id: id
        size: 16
        type: strz
      - id: name
        size: 128
        type: strz
      - id: lower_name
        size: 128
        type: strz
      - id: subtitle
        type: v_string(_io.pos)
      - id: description
        type: v_string(_io.pos)
      - id: hint
        size: 32
        type: strz
      - id: group_id
        size: 16
        type: strz
      - id: debris
        type: filename_ref
      - id: base_value
        type: u4
      - id: level
        type: u4
      - id: icon
        type: filename_ref
      - id: hero_icon
        type: filename_ref
      - size: 12
      - id: color
        type: color
      - id: substance_category
        type: u4
        enum: substance_category
      - id: type
        type: u4
        enum: product_category
      - id: rarity
        type: u4
        enum: rarity
      - id: legality
        type: u4
        enum: legality
      - id: consumable
        type: u1
        enum: boolean
      - size: 3
      - id: charge_value
        type: u4
      - id: stack_multiplier
        type: u4
      - id: default_craft_amount
        type: u4
      - id: craft_amount_step_size
        type: u4
      - id: craft_amount_multiplier
        type: u4
      - id: requirements
        type: list(_io.pos, "technology_requirement")
      - id: alt_requirements
        type: list(_io.pos, "technology_requirement")
      - id: cost
        type: item_price_modifiers
      - id: recipe_cost
        type: u4
      - id: specific_charge_only
        type: u1
      - size: 3
      - id: normalized_value_on_world
        type: f4
      - id: normalized_value_off_world
        type: f4
      - id: trade_category
        type: u4
        enum: trade_category
      - id: wiki_category
        type: u4
        enum: wiki_category
      - id: is_craftable
        type: u1
        enum: boolean
      - size: 3
      - id: deploys_into
        size: 16
        type: strz
      - id: economy_influence_multiplier
        type: f4
      - size: 4
      - id: pin_objective
        size: 32
        type: strz
      - id: pin_objective_tip
        size: 32
        type: strz
      - id: cooking_ingredient
        type: u1
        enum: boolean
      - size: 3
      - id: cooking_value
        type: f4
      - size: 8

  technology_requirement:
    seq:
      - id: id
        size: 16
        type: strz
      - id: inventory_type
        type: u4
        enum: inventory_type
      - id: amount
        type: u4

  stats_bonus:
    seq:
      - id: type
        type: u4
        enum: stats_type
      - id: bonus
        type: f4
      - id: level
        type: u4

  item_price_modifiers:
    seq:
      - id: space_station_markup
        type: f4
      - id: low_price_mod
        type: f4
      - id: high_price_mod
        type: f4
      - id: buy_base_markup
        type: f4
      - id: buy_markup_mod
        type: f4

  filename_ref:
    seq:
      - id: filename
        size: 128
        type: strz
      - size: 4

  color:
    seq:
      - id: r
        type: f4
      - id: g
        type: f4
      - id: b
        type: f4
      - id: a
        type: f4

  refiner_recipe:
    seq:
      - id: id
        size: 32
        type: strz
      - id: name
        size: 32
        type: strz
      - id: time_to_make
        type: f4
      - id: cooking
        type: u4
        enum: boolean
      - id: result
        type: refiner_recipe_element
      - id: ingredients
        type: list(_io.pos, "refiner_recipe_element")

  refiner_recipe_element:
    seq:
      - id: id
        size: 16
        type: strz
      - id: type
        type: u4
        enum: inventory_type
      - id: amount
        type: u4

  substance_entry:
    seq:
      - id: name
        size: 32
        type: strz
      - id: lower_name
        size: 32
        type: strz
      - id: id
        size: 16
        type: strz
      - id: symbol
        size: 32
        type: strz
      - id: icon
        type: filename_ref
      - id: debris
        type: filename_ref
      - id: subtitle
        type: v_string(_io.pos)
      - id: description
        type: v_string(_io.pos)
      - size: 8
      - id: color
        type: color
      - id: world_color
        type: color
      - id: base_value
        type: u4
      - id: category
        type: u4
        enum: substance_category
      - id: rarity
        type: u4
        enum: rarity
      - id: legality
        type: u4
        enum: legality
      - id: charge_value
        type: u4
      - id: stack_multiplier
        type: u4
      - id: cost
        type: item_price_modifiers
      - id: normalized_value_on_world
        type: f4
      - id: normalized_value_off_world
        type: f4
      - id: trade_category
        type: u4
        enum: trade_category
      - id: wiki_enabled
        type: u4
        enum: boolean
      - id: economy_influence_multiplier
        type: f4
      - id: pin_objective
        size: 32
        type: strz
      - id: pin_objective_tip
        size: 32
        type: strz
      - id: wiki_mission_id
        size: 16
        type: strz
      - id: cooking_ingredient
        type: u1
        enum: boolean
      - size: 15

enums:
  boolean:
    0: false
    1: true

  substance_category:
    0: fuel
    1: metal
    2: catalyst
    3: stellar
    4: flora
    5: earth
    6: exotic
    7: special
    8: building_part

  technology_category:
    0: ship
    1: weapon
    2: suit
    3: personal
    4: all
    5: none
    6: freighter
    7: maintenance
    8: exocraft
    9: submarine
    10: all_vehicles

  technology_rarity:
    0: normal
    1: very_common
    2: common
    3: rare
    4: very_rare
    5: impossible
    6: always

  stats_type:
    0: unspecified
    1: weapon_laser
    2: weapon_laser_damage
    3: weapon_laser_mining_speed
    4: weapon_laser_heattime
    5: weapon_laser_bounce
    6: weapon_laser_reloadtime
    7: weapon_laser_recoil
    8: weapon_laser_drain
    9: weapon_laser_stronglaser
    10: weapon_laser_chargetime
    11: weapon_laser_miningbonus
    12: weapon_projectile
    13: weapon_projectile_damage
    14: weapon_projectile_range
    15: weapon_projectile_rate
    16: weapon_projectile_clipsize
    17: weapon_projectile_reloadtime
    18: weapon_projectile_recoil
    19: weapon_projectile_bounce
    20: weapon_projectile_homing
    21: weapon_projectile_dispersion
    22: weapon_projectile_bulletspershot
    23: weapon_projectile_maximumcharge
    24: weapon_rail
    25: weapon_shotgun
    26: weapon_burst
    27: weapon_grenade
    28: weapon_grenade_damage
    29: weapon_grenade_radius
    30: weapon_grenade_speed
    31: weapon_grenade_bounce
    32: weapon_grenade_homing
    33: weapon_grenade_clusterbomb
    34: weapon_terrainedit
    35: weapon_minegrenade
    36: weapon_frontshield
    37: weapon_scope
    38: weapon_scan
    39: weapon_scan_radius
    40: weapon_scan_recharge_time
    41: weapon_scan_types
    42: weapon_scan_binoculars
    43: weapon_scan_discovery_creature
    44: weapon_scan_discovery_flora
    45: weapon_scan_secondary
    46: weapon_scan_terrain_resource
    47: weapon_scan_surveying
    48: suit_armour_health
    49: suit_armour_shield
    50: suit_armour_shield_strength
    51: suit_energy
    52: suit_energy_regen
    53: suit_protection
    54: suit_protection_cold
    55: suit_protection_heat
    56: suit_protection_toxic
    57: suit_protection_radiation
    58: suit_underwater
    59: suit_underwaterlifesupport
    60: suit_damagereduce_cold
    61: suit_damagereduce_heat
    62: suit_damagereduce_toxic
    63: suit_damagereduce_radiation
    64: suit_protection_heatdrain
    65: suit_protection_colddrain
    66: suit_protection_toxdrain
    67: suit_protection_raddrain
    68: suit_protection_waterdrain
    69: suit_stamina_strength
    70: suit_stamina_speed
    71: suit_jetpack
    72: suit_jetpack_tank
    73: suit_jetpack_drain
    74: suit_jetpack_ignition
    75: suit_jetpack_doublejump
    76: suit_jetpack_waterefficiency
    77: suit_autotranslator
    78: suit_utility
    79: ship_weapons_guns
    80: ship_weapons_guns_damage
    81: ship_weapons_guns_rate
    82: ship_weapons_guns_heattime
    83: ship_weapons_guns_cooltime
    84: ship_weapons_guns_scale
    85: ship_weapons_guns_bulletspershot
    86: ship_weapons_guns_dispersion
    87: ship_weapons_guns_range
    88: ship_weapons_guns_damage_radius
    89: ship_weapons_lasers
    90: ship_weapons_lasers_damage
    91: ship_weapons_lasers_heattime
    92: ship_weapons_missiles
    93: ship_weapons_missiles_numpershot
    94: ship_weapons_missiles_speed
    95: ship_weapons_missiles_damage
    96: ship_weapons_missiles_size
    97: ship_weapons_shotgun
    98: ship_weapons_minigun
    99: ship_weapons_plasma
    100: ship_weapons_rockets
    101: ship_armour_shield
    102: ship_armour_shield_strength
    103: ship_armour_health
    104: ship_scan
    105: ship_scan_economyfilter
    106: ship_scan_conflictfilter
    107: ship_hyperdrive
    108: ship_hyperdrive_jumpdistance
    109: ship_hyperdrive_jumpspercell
    110: ship_launcher
    111: ship_launcher_takeoffcost
    112: ship_launcher_autocharge
    113: ship_pulsedrive
    114: ship_pulsedrive_minijumpfuelspending
    115: ship_boost
    116: ship_maneuverability
    117: ship_boostmaneuverability
    118: ship_teleport
    119: freighter_hyperdrive
    120: freighter_hyperdrive_jumpdistance
    121: vehicle_boost
    122: vehicle_engine
    123: vehicle_scan
    124: vehicle_enginefueluse
    125: vehicle_enginetopspeed
    126: vehicle_boostspeed
    127: vehicle_boosttanks
    128: vehicle_grip
    129: vehicle_skidgrip
    130: vehicle_subboostspeed
    131: vehicle_laser
    132: vehicle_laserdamage
    133: vehicle_laserheattime
    134: vehicle_laserstronglaser
    135: vehicle_gun
    136: vehicle_gundamage
    137: vehicle_gunheattime
    138: vehicle_gunrate

  alien_race:
    0: traders
    1: warriors
    2: explorers
    3: robots
    4: atlas
    5: diplomats
    6: exotics
    7: none

  inventory_type:
    0: substance
    1: technology
    2: product

  product_category:
    0: component
    1: consumable
    2: tradeable
    3: curiosity
    4: building_part
    5: procedural
    6: emote
    7: customization_part

  rarity:
    0: common
    1: uncommon
    2: rare

  legality:
    0: legal
    1: illegal
    2: none

  trade_category:
    0: mineral
    1: tech
    2: commodity
    3: component
    4: alloy
    5: exotic
    6: energy
    7: none

  wiki_category:
    0: not_enabled
    1: crafting
    2: tech
    3: construction
    4: trade
    5: curio
    6: cooking
