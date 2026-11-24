# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity/19_craft_bench.ksy
# Licence and copyright: see _community/README.md
meta:
  id: craft_bench
  title: 'Project Zomboid save: craft bench entity component'
  license: MIT
  imports:
    - common
    - inventory
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.entity.components.crafting.CraftBench.save / load
  - id: recipe_tag_query
    type: common::string_utf
  # EnumBitStore<ResourceChannel>.save -> u4 bits
  - id: fluid_input_channels_bits
    type: u4
  - id: energy_input_channels_bits
    type: u4
