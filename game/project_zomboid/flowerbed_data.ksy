# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/erosion/30_flowerbed.ksy
meta:
  id: flowerbed_data
  title: 'Project Zomboid save: erosion flowerbed data'
  license: MIT
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.erosion.categories.Flowerbed.CategoryData.load
  - id: game_obj
    type: u1
