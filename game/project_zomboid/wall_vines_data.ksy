# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/erosion/20_wall_vines.ksy
meta:
  id: wall_vines_data
  title: 'Project Zomboid save: erosion wall vines data'
  license: MIT
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.erosion.categories.WallVines.CategoryData.load
  - id: game_obj
    type: u1
  - id: max_stage
    type: u1
  - id: spawn_time
    type: u2
  - id: cur_id
    type: s4
  - id: has_top
    type: u1
  - id: top
    type: wall_vines_top
    if: has_top != 0
types:
  wall_vines_top:
    seq:
      - id: game_obj
        type: u1
      - id: spawn_time
        type: u2
      - id: cur_id
        type: s4
