# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/29_light_switch.ksy
# Licence and copyright: see _community/README.md
meta:
  id: light_switch
  title: 'Project Zomboid save: light switch object'
  license: MIT
  imports:
    - common
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  - id: light_room
    type: u1
  - id: room_id
    type: s8
    if: world_version >= 206
  - id: room_index
    type: s4
    if: world_version < 206
  - id: activated
    type: u1
  - id: can_be_modified
    type: u1
  - id: use_battery
    type: u1
    if: can_be_modified == 1
  - id: has_battery
    type: u1
    if: can_be_modified == 1
  - id: bulb_item_present
    type: u1
    if: can_be_modified == 1
  - id: bulb_item
    type: common::string_utf
    if: can_be_modified == 1 and bulb_item_present == 1
  - id: power
    type: f4
    if: can_be_modified == 1
  - id: delta
    type: f4
    if: can_be_modified == 1
  - id: primary_r
    type: f4
    if: can_be_modified == 1
  - id: primary_g
    type: f4
    if: can_be_modified == 1
  - id: primary_b
    type: f4
    if: can_be_modified == 1
  - id: last_minute_stamp
    type: s8
  - id: bulb_burn_minutes
    type: s4
