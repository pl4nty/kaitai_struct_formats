# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/entity/11_ui_config.ksy
meta:
  id: ui_config
  title: 'Project Zomboid save: UI config entity component'
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
  # zombie.entity.components.ui.UiConfig.save/load
  - id: has_skin
    type: u1
  - id: xui_skin_name
    type: common::string_utf
    if: has_skin != 0
  - id: has_style
    type: u1
  - id: entity_style_name
    type: common::string_utf
    if: has_style != 0
  - id: ui_enabled
    type: u1
