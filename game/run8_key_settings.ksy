# Imported from https://github.com/Puyodead1/Run8-V3-reverse-engineering/blob/9695472b0729acbd1bb8a0ebcaddb01f91f40b76/misc/ksy/ksy/key_settings.ksy
meta:
  id: run8_key_settings
  title: Key Settings (Run8KeySettings.r8)
  application: Run8 Train Simulator
  file-extension: r8
  license: LicenseRef-All-Rights-Reserved
  imports:
    - run8_common
  endian: le
doc: Stores game keybind settings
seq:
  - id: reserved
    type: s4
  - id: num_settings
    type: s4
  - id: settings
    type: key_setting
    repeat: expr
    repeat-expr: num_settings

types:
  key_setting:
    seq:
      - id: reserved
        type: s4
      - id: name
        type: run8_common::r8string
      - id: enum70
        type: s1
      - id: num_keys
        type: s4
      - id: keys
        type: s4
        repeat: expr
        repeat-expr: num_keys
