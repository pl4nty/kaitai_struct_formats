# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/iso_object/37_feeding_trough.ksy
# Licence and copyright: see _community/README.md
meta:
  id: feeding_trough
  title: 'Project Zomboid save: feeding trough object'
  license: MIT
  imports:
    - common
  endian: be
params:
  - id: context
    type: any
  - id: world_version
    type: u4
  - id: debug
    type: u1
seq:
  - id: num_feeding_types
    type: s4
  - id: feeding_types
    type: feeding_type_entry
    repeat: expr
    repeat-expr: num_feeding_types
  - id: water
    type: f4
  - id: is_slave
    type: u1
  - id: linked_x
    type: s4
    if: is_slave == 1
  - id: linked_y
    type: s4
    if: is_slave == 1
  - id: north
    type: u1
types:
  feeding_type_entry:
    seq:
      - id: food_type
        type: common::string_utf
      - id: amount
        type: f4
