# Imported from https://github.com/nnguyen259/SenSchema/blob/25e06d9b529904dcc1b3ca3e8e320a42ac88ff89/schemas/components/common/element.ksy
meta:
  id: element
  title: Trails of Cold Steel III element ID
  license: MIT
  endian: le
seq:
  - id: element_id
    type: u2
    enum: elements
enums:
  elements:
    0: no_element
    1: earth
    2: water
    3: fire
    4: wind
    5: time
    6: space
    7: mirage
