# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/erosion/21_wall_cracks.ksy
# Licence and copyright: see _community/README.md
meta:
  id: wall_cracks_data
  title: 'Project Zomboid save: erosion wall cracks data'
  license: MIT
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.erosion.categories.WallCracks.CategoryData.load
  - id: game_obj
    type: u1
  - id: spawn_time
    type: u2
  - id: cur_id
    type: s4
  - id: alpha
    type: f4
  - id: has_top
    type: u1
  - id: top
    type: wall_cracks_top
    if: has_top != 0
types:
  wall_cracks_top:
    seq:
      - id: game_obj
        type: u1
      - id: spawn_time
        type: u2
      - id: cur_id
        type: s4
      - id: alpha
        type: f4
