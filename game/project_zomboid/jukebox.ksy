# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/7_jukebox.ksy
# Licence and copyright: see _community/README.md
meta:
  id: jukebox
  title: 'Project Zomboid save: jukebox object'
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
  # IsoJukebox has no load method override
  []
