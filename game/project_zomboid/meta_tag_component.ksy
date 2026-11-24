# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity/17_meta_tag_component.ksy
meta:
  id: meta_tag_component
  title: 'Project Zomboid save: meta tag entity component'
  license: MIT
  imports:
    - common
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
seq:
  # zombie.entity.meta.MetaTagComponent.save / load
  - id: stored_id
    type: u8
