# Imported from https://github.com/Puyodead1/Run8-V3-reverse-engineering/blob/9695472b0729acbd1bb8a0ebcaddb01f91f40b76/misc/ksy/ksy/ai_track_speed_database.ksy
meta:
  id: run8_ai_track_speed_database
  title: AITrackSpeedDatabase (AITrackSpeedDatabase.r8)
  application: Run8 Train Simulator
  file-extension: r8
  license: LicenseRef-All-Rights-Reserved
  imports:
    - run8_common
  endian: le
doc: Contains a list of AI Track Speeds
seq:
  - id: reserved
    type: s4
  - id: num_entries
    type: s4
  - id: entries
    type: ai_track_speed
    repeat: expr
    repeat-expr: num_entries

types:
  ai_track_speed:
    seq:
      - id: reserved
        type: s4
      - id: int1
        type: s4
      - id: num_entries
        type: s4
      - id: entries
        type: class_322
        repeat: expr
        repeat-expr: num_entries
  class_322:
    seq:
      - id: reserved
        type: s4
      - id: int1
        type: s4
      - id: int2
        type: s4
      - id: int3
        type: s4
