# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/erosion/10_street_cracks.ksy
meta:
  id: street_cracks_data
  title: 'Project Zomboid save: erosion street cracks data'
  license: MIT
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.erosion.categories.StreetCracks.CategoryData.load
  - id: game_obj
    type: u1
  - id: max_stage
    type: u1
  - id: spawn_time
    type: u2
  - id: cur_id
    type: s4
  - id: has_grass
    type: u1
