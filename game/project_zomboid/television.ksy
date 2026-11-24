# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/10_television.ksy
meta:
  id: television
  title: 'Project Zomboid save: television object'
  license: MIT
  imports:
    - iso_object_shared
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  - id: television
    type: iso_object_shared::iso_wave_signal
