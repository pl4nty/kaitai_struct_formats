# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/27_barricade.ksy
meta:
  id: barricade
  title: 'Project Zomboid save: barricade object'
  license: MIT
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  # NOTE: IsoBarricade does NOT call super.load()
  - id: dir_index
    type: u1
  - id: num_planks
    type: u1
  - id: plank_healths
    type: s2
    repeat: expr
    repeat-expr: num_plank_healths
    doc: Only first 4 values are used in game logic
  - id: metal_health
    type: s2
  - id: metal_bar_health
    type: s2
instances:
  num_plank_healths:
    value: num_planks
