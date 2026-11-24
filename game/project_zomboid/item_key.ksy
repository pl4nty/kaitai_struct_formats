# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/key.ksy
# Licence and copyright: see _community/README.md
meta:
  id: item_key
  title: 'Project Zomboid save: key inventory item'
  license: MIT
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4

seq:
  - id: key_id
    type: s4
  - id: number_of_keys
    type: u1
