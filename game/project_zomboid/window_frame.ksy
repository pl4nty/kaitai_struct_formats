# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/41_window_frame.ksy
# Licence and copyright: see _community/README.md
meta:
  id: window_frame
  title: 'Project Zomboid save: window frame object'
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
  - id: north
    type: u1
