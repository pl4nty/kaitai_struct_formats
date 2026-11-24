# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/32_fire.ksy
# Licence and copyright: see _community/README.md
meta:
  id: fire
  title: 'Project Zomboid save: fire object'
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
  - id: life
    type: s4
  - id: spread_delay
    type: s4
  - id: life_stage
    type: s4
  - id: life_stage_timer
    type: s4
  - id: life_stage_duration
    type: s4
  - id: energy
    type: s4
  - id: num_flame_particles
    type: s4
  - id: spread_timer
    type: s4
  - id: age
    type: s4
  - id: perm
    type: u1
  - id: light_radius
    type: u1
  - id: smoke
    type: u1
