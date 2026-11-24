# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/stage.ksy
meta:
  id: groove_coaster_stage
  title: Groove Coaster stage/song parameters
  license: LicenseRef-All-Rights-Reserved
  imports:
    - groove_coaster_str_container
  endian: be
doc: |
  Recovered from TuneAppMain::LoadStageData. The loader selects one string
  from each of the first two localized pairs according to the active language.
seq:
  - id: num_stages
    type: u2
  - id: stages
    type: stage_entry
    repeat: expr
    repeat-expr: num_stages
types:
  stage_entry:
    seq:
      - { id: title_1, type: groove_coaster_str_container }
      - { id: title_2, type: groove_coaster_str_container }
      - { id: stage_id, type: u2 }
      - { id: artist_1, type: groove_coaster_str_container }
      - { id: artist_2, type: groove_coaster_str_container }
      - { id: duration_text, type: groove_coaster_str_container }
      - { id: byte_01, type: u1 }
      - { id: byte_02, type: u1 }
      - { id: byte_03, type: u1 }
      - { id: byte_04, type: u1 }
      - { id: byte_05, type: u1 }
      - { id: byte_06, type: u1 }
      - { id: string_06, type: groove_coaster_str_container }
      - { id: string_07, type: groove_coaster_str_container }
      - { id: string_08, type: groove_coaster_str_container }
      - { id: byte_07, type: u1 }
      - { id: byte_08, type: u1 }
      - { id: byte_09, type: u1 }
      - { id: chart_easy, type: groove_coaster_str_container }
      - { id: chart_normal, type: groove_coaster_str_container }
      - { id: chart_hard, type: groove_coaster_str_container }
      - { id: value_01, type: u4 }
      - { id: value_02, type: u4 }
      - { id: value_03, type: u4 }
      - { id: value_04, type: u4 }
      - { id: value_05, type: u4 }
      - { id: value_06, type: u4 }
      - { id: value_07, type: u4 }
      - { id: byte_10, type: u1 }
      - { id: value_08, type: u4 }
      - { id: byte_11, type: u1 }
      - { id: value_09, type: u4 }
      - { id: string_09, type: groove_coaster_str_container }
      - { id: byte_12, type: u1 }
      - { id: value_10, type: u4 }
      - { id: byte_13, type: u1 }
