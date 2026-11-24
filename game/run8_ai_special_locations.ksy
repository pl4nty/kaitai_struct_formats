# Imported from https://github.com/Puyodead1/Run8-V3-reverse-engineering/blob/9695472b0729acbd1bb8a0ebcaddb01f91f40b76/misc/ksy/ksy/ai_special_locations.ksy
meta:
  id: run8_ai_special_locations
  title: AISpecialLocations (AISpecialLocations.r8)
  application: Run8 Train Simulator
  file-extension: r8
  license: LicenseRef-All-Rights-Reserved
  imports:
    - run8_common
  endian: le
doc: Contains a list of AI Special Locations
seq:
  - id: reserved
    type: s4
  - id: num_entries
    type: s4
  - id: entries
    type: ai_special_location
    repeat: expr
    repeat-expr: num_entries

types:
  ai_special_location:
    seq:
      - id: reserved
        type: s4
      - id: name
        type: run8_common::r8string
      - id: type
        type: u1
        enum: ai_special_location_type
      - id: int1
        type: s4
      - id: int2
        type: s4
      - id: int3
        type: s4
      - id: float1
        type: f4
      - id: int4
        type: s4
      - id: bool1
        type: run8_common::boolean

enums:
  ai_special_location_type:
    0: spawn_point
    1: crew_change
    2: crew_change_and_hold
    3: passenger
    4: passenger_crew_change
    5: passenger_crew_change_and_hold
    6: reliquish
    7: passenger_reliquish
