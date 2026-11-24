# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/erosion/03_generic.ksy
meta:
  id: generic_data
  title: 'Project Zomboid save: erosion generic data'
  license: MIT
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.erosion.categories.NatureGeneric.CategoryData.load
  - id: game_obj
    type: u1
  - id: max_stage
    type: u1
  - id: spawn_time
    type: u2
  - id: not_grass
    type: u1
