# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/39_animal_track.ksy
meta:
  id: animal_track
  title: 'Project Zomboid save: animal track object'
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
  - id: animal_type
    type: common::string_utf
  - id: track_type
    type: common::string_utf
  - id: x
    type: s4
  - id: y
    type: s4
  - id: has_dir
    type: u1
  - id: dir_index
    type: s4
    if: has_dir == 1
  - id: added_time
    type: s8
  - id: added_to_world
    type: u1
