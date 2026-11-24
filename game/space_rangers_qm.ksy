meta:
  id: space_rangers_qm
  title: Space Rangers Text Quest
  application:
    - TGE
    - Space Rangers
    - "Space Rangers 2: Dominators"
  file-extension:
    - qm
    - qmm
  license: Unlicense
  encoding: UTF-16LE
  endian: le
doc: |
  Text quest ("planetary quest") made with TGE (Text Game Editor) for the
  Space Rangers games. Two families exist:

    * `.qm` (magic 0x423A35D2/3/4): fixed parameter count (24/48/96),
      every location and jump stores an entry for every parameter;
    * `.qmm` (magic 0x423A35D6/7, or 0x069F6BD7): explicit parameter count,
      locations and jumps store only the parameters they touch, and most
      texts can carry an image, sound and music track.

  The layout follows `parse()` in qmreader.ts of the open-source Space
  Rangers quest player (see doc-ref); field names in `-orig-id` are the
  property names used there.

  You can download quests from:
    * the sites mentioned on https://ifwiki.ru/TGE
    * http://www.rilarhiv.ru/tge2.htm
doc-ref:
  - "https://github.com/roginvs/space-rangers-quest/blob/ad86c9bb720a6f7aa11a6d9b04a12e08d7dc3187/src/lib/qmreader.ts"
  - "http://www.abaduaber.narod.ru/lastqm.txt"
  - "https://github.com/ObKo/OpenSR/blob/rework/QM/QM.cpp"
seq:
  - id: magic
    -orig-id: header
    type: u4
    enum: magic
    valid:
      any-of:
        - magic::qm_2
        - magic::qm_3
        - magic::qm_4
        - magic::qmm_6
        - magic::qmm_7
        - magic::qmm_7_old_tge_behaviour
  - id: header
    type:
      switch-on: is_qmm
      cases:
        true: header_qmm
        false: header_qm
    doc: qmreader.ts parseBase()
  - id: params
    type:
      switch-on: is_qmm
      cases:
        true: param_qmm
        false: param_qm
    repeat: expr
    repeat-expr: num_params
  - id: strings
    type: quest_strings
    doc: qmreader.ts parseBase2()
  - id: locations
    type:
      switch-on: is_qmm
      cases:
        true: location_qmm
        false: location_qm
    repeat: expr
    repeat-expr: strings.locations_count
  - id: jumps
    type:
      switch-on: is_qmm
      cases:
        true: jump_qmm
        false: jump_qm
    repeat: expr
    repeat-expr: strings.jumps_count
instances:
  is_qmm:
    value: >-
      magic == magic::qmm_6 or magic == magic::qmm_7
      or magic == magic::qmm_7_old_tge_behaviour
  is_v7:
    value: magic == magic::qmm_7 or magic == magic::qmm_7_old_tge_behaviour
  num_params:
    -orig-id: paramsCount
    value: >-
      is_qmm ? header.as<header_qmm>.num_params :
      magic == magic::qm_2 ? 24 :
      magic == magic::qm_3 ? 48 : 96
enums:
  magic:
    0x423a35d2: qm_2
    0x423a35d3: qm_3
    0x423a35d4: qm_4
    0x423a35d6: qmm_6
    0x423a35d7: qmm_7
    0x069f6bd7:
      id: qmm_7_old_tge_behaviour
      doc: |
        Version 7 quest resaved from an older one; tells the player to keep
        the old TGE behaviour.
  when_done:
    0: on_return
    1: on_finish
  param_type:
    0: normal
    1: fail
    2: success
    3: death
  crit_type:
    0: max
    1: min
  showing_type:
    0: no_change
    1: show
    2: hide
  change_type:
    0: value
    1: sum
    2: percentage
    3: formula
  location_type:
    0: ordinary
    1: starting
    2: empty
    3: success
    4: fail
    5: deadly
types:
  sr_str:
    doc: |
      Optional string: a non-zero int32 flag followed by an int32 length in
      UTF-16 code units and the text (qmreader.ts Reader.readString()).
    seq:
      - id: present
        type: s4
      - id: len_value
        type: s4
        if: present != 0
      - id: value
        size: len_value * 2
        type: str
        if: present != 0
  race:
    doc: Race bit set (qmreader.ts PlayerRace / PlanetRace).
    seq:
      - id: reserved0
        type: b1
      - id: uninhabited
        type: b1
        doc: Only meaningful for planet races.
      - id: reserved1
        type: b1
      - id: gaal
        type: b1
      - id: faeyan
        type: b1
      - id: human
        type: b1
      - id: peleng
        type: b1
      - id: maloq
        type: b1
  player_career:
    doc: Career bit set (qmreader.ts PlayerCareer).
    seq:
      - id: reserved
        type: b5
      - id: warrior
        type: b1
      - id: pirate
        type: b1
      - id: merchant
        type: b1
  header_qm:
    seq:
      - id: unknown1
        type: u4
      - id: giving_race
        -orig-id: givingRace
        type: race
      - id: when_done
        -orig-id: whenDone
        type: u1
        enum: when_done
      - id: unknown2
        type: u4
      - id: planet_race
        -orig-id: planetRace
        type: race
      - id: unknown3
        type: u4
      - id: player_career
        -orig-id: playerCareer
        type: player_career
      - id: unknown4
        type: u4
      - id: player_race
        -orig-id: playerRace
        type: race
      - id: reputation_change
        -orig-id: reputationChange
        type: s4
      - id: screen_size_x
        -orig-id: screenSizeX
        type: s4
        doc: pixels
      - id: screen_size_y
        -orig-id: screenSizeY
        type: s4
        doc: pixels
      - id: width_size
        -orig-id: widthSize
        type: s4
        doc: Grid width
      - id: height_size
        -orig-id: heightSize
        type: s4
        doc: Grid height
      - id: unknown5
        type: u4
      - id: default_jump_count_limit
        -orig-id: defaultJumpCountLimit
        type: s4
        doc: 0 is unlimited
      - id: hardness
        type: s4
        doc: Difficulty, percent
  header_qmm:
    seq:
      - id: major_version
        -orig-id: majorVersion
        type: s4
        if: _root.is_v7
      - id: minor_version
        -orig-id: minorVersion
        type: s4
        if: _root.is_v7
      - id: change_log
        -orig-id: changeLogString
        type: sr_str
        if: _root.is_v7
      - id: giving_race
        -orig-id: givingRace
        type: race
      - id: when_done
        -orig-id: whenDone
        type: u1
        enum: when_done
      - id: planet_race
        -orig-id: planetRace
        type: race
      - id: player_career
        -orig-id: playerCareer
        type: player_career
      - id: player_race
        -orig-id: playerRace
        type: race
      - id: reputation_change
        -orig-id: reputationChange
        type: s4
      - id: screen_size_x
        -orig-id: screenSizeX
        type: s4
        doc: pixels
      - id: screen_size_y
        -orig-id: screenSizeY
        type: s4
        doc: pixels
      - id: width_size
        -orig-id: widthSize
        type: s4
        doc: Grid width
      - id: height_size
        -orig-id: heightSize
        type: s4
        doc: Grid height
      - id: default_jump_count_limit
        -orig-id: defaultJumpCountLimit
        type: s4
        doc: 0 is unlimited
      - id: hardness
        type: s4
        doc: Difficulty, percent
      - id: num_params
        -orig-id: paramsCount
        type: s4
  showing_range:
    seq:
      - id: range_from
        -orig-id: from
        type: s4
      - id: range_to
        -orig-id: to
        type: s4
      - id: label
        -orig-id: str
        type: sr_str
  media:
    seq:
      - id: img
        type: sr_str
      - id: sound
        type: sr_str
      - id: track
        type: sr_str
  param_qm:
    doc: qmreader.ts parseParam()
    seq:
      - id: min
        type: s4
      - id: max
        type: s4
      - id: unknown1
        type: s4
      - id: type
        type: u1
        enum: param_type
      - id: unknown2
        type: u4
      - id: show_when_zero
        -orig-id: showWhenZero
        type: u1
      - id: crit_type
        -orig-id: critType
        type: u1
        enum: crit_type
      - id: active
        type: u1
      - id: num_showing_info
        -orig-id: showingRangesCount
        type: s4
      - id: is_money
        -orig-id: isMoney
        type: u1
      - id: name
        type: sr_str
      - id: showing_info
        -orig-id: showingInfo
        type: showing_range
        repeat: expr
        repeat-expr: num_showing_info
      - id: crit_value_string
        -orig-id: critValueString
        type: sr_str
      - id: starting
        type: sr_str
  param_qmm:
    doc: qmreader.ts parseParamQmm()
    seq:
      - id: min
        type: s4
      - id: max
        type: s4
      - id: type
        type: u1
        enum: param_type
      - id: unknown
        size: 3
      - id: show_when_zero
        -orig-id: showWhenZero
        type: u1
      - id: crit_type
        -orig-id: critType
        type: u1
        enum: crit_type
      - id: active
        type: u1
      - id: num_showing_info
        -orig-id: showingRangesCount
        type: s4
      - id: is_money
        -orig-id: isMoney
        type: u1
      - id: name
        type: sr_str
      - id: showing_info
        -orig-id: showingInfo
        type: showing_range
        repeat: expr
        repeat-expr: num_showing_info
      - id: crit_value_string
        -orig-id: critValueString
        type: sr_str
      - id: media
        type: media
      - id: starting
        type: sr_str
  quest_strings:
    doc: qmreader.ts parseBase2()
    seq:
      - id: to_star
        -orig-id: ToStar
        type: sr_str
      - id: parsec
        -orig-id: Parsec
        type: sr_str
        if: not _root.is_qmm
      - id: artefact
        -orig-id: Artefact
        type: sr_str
        if: not _root.is_qmm
      - id: to_planet
        -orig-id: ToPlanet
        type: sr_str
      - id: date
        -orig-id: Date
        type: sr_str
      - id: money
        -orig-id: Money
        type: sr_str
      - id: from_planet
        -orig-id: FromPlanet
        type: sr_str
      - id: from_star
        -orig-id: FromStar
        type: sr_str
      - id: ranger
        -orig-id: Ranger
        type: sr_str
      - id: locations_count
        -orig-id: locationsCount
        type: s4
      - id: jumps_count
        -orig-id: jumpsCount
        type: s4
      - id: success_text
        -orig-id: successText
        type: sr_str
      - id: task_text
        -orig-id: taskText
        type: sr_str
      - id: unknown_text
        -orig-id: unknownText
        type: sr_str
        if: not _root.is_qmm
  location_param_change_qm:
    doc: One entry per quest parameter (qmreader.ts parseLocation()).
    seq:
      - id: unknown1
        size: 12
      - id: change
        type: s4
      - id: showing_type
        -orig-id: showingType
        type: u1
        enum: showing_type
      - id: unknown2
        size: 4
      - id: is_change_percentage
        -orig-id: isChangePercentage
        type: u1
      - id: is_change_value
        -orig-id: isChangeValue
        type: u1
      - id: is_change_formula
        -orig-id: isChangeFormula
        type: u1
      - id: changing_formula
        -orig-id: changingFormula
        type: sr_str
      - id: unknown3
        size: 10
      - id: crit_text
        -orig-id: critText
        type: sr_str
  location_qm:
    doc: qmreader.ts parseLocation()
    seq:
      - id: day_passed
        -orig-id: dayPassed
        type: s4
      - id: loc_x
        -orig-id: locX
        type: s4
      - id: loc_y
        -orig-id: locY
        type: s4
      - id: id
        type: s4
      - id: is_starting
        -orig-id: isStarting
        type: u1
      - id: is_success
        -orig-id: isSuccess
        type: u1
      - id: is_faily
        -orig-id: isFaily
        type: u1
      - id: is_faily_deadly
        -orig-id: isFailyDeadly
        type: u1
      - id: is_empty
        -orig-id: isEmpty
        type: u1
      - id: params_changes
        -orig-id: paramsChanges
        type: location_param_change_qm
        repeat: expr
        repeat-expr: _root.num_params
      - id: texts
        type: sr_str
        repeat: expr
        repeat-expr: 10
        doc: LOCATION_TEXTS in qmreader.ts
      - id: is_text_by_formula
        -orig-id: isTextByFormula
        type: u1
      - id: unknown1
        size: 4
      - id: unknown_str1
        type: sr_str
      - id: unknown_str2
        type: sr_str
      - id: text_select_formula
        -orig-id: textSelectFormula
        type: sr_str
  param_change_qmm:
    doc: A parameter change in a location or jump (.qmm only).
    seq:
      - id: param_n
        -orig-id: paramN
        type: s4
        doc: 1-based parameter number
      - id: change
        type: s4
      - id: showing_type
        -orig-id: showingType
        type: u1
        enum: showing_type
      - id: change_type
        -orig-id: changeType
        type: u1
        enum: change_type
      - id: changing_formula
        -orig-id: changingFormula
        type: sr_str
      - id: crit_text
        -orig-id: critText
        type: sr_str
      - id: media
        type: media
  location_text_qmm:
    seq:
      - id: text
        type: sr_str
      - id: media
        type: media
  location_qmm:
    doc: qmreader.ts parseLocationQmm()
    seq:
      - id: day_passed
        -orig-id: dayPassed
        type: s4
      - id: loc_x
        -orig-id: locX
        type: s4
        doc: pixels
      - id: loc_y
        -orig-id: locY
        type: s4
        doc: pixels
      - id: id
        type: s4
      - id: max_visits
        -orig-id: maxVisits
        type: s4
      - id: type
        type: u1
        enum: location_type
      - id: num_params_changes
        -orig-id: affectedParamsCount
        type: s4
      - id: params_changes
        -orig-id: paramsChanges
        type: param_change_qmm
        repeat: expr
        repeat-expr: num_params_changes
      - id: num_texts
        -orig-id: locationTexts
        type: s4
      - id: texts
        type: location_text_qmm
        repeat: expr
        repeat-expr: num_texts
      - id: is_text_by_formula
        -orig-id: isTextByFormula
        type: u1
      - id: text_select_formula
        -orig-id: textSelectFormula
        type: sr_str
  int_set:
    doc: |
      Value list of a jump condition: the parameter must (flag != 0) or must
      not equal / be divisible by one of the values.
    seq:
      - id: num_values
        type: s4
      - id: flag
        type: u1
      - id: values
        type: s4
        repeat: expr
        repeat-expr: num_values
  jump_param_qm:
    doc: One entry per quest parameter (qmreader.ts parseJump()).
    seq:
      - id: unknown1
        size: 4
      - id: must_from
        -orig-id: mustFrom
        type: s4
      - id: must_to
        -orig-id: mustTo
        type: s4
      - id: change
        type: s4
      - id: showing_type
        -orig-id: showingType
        type: s4
        enum: showing_type
      - id: unknown2
        size: 1
      - id: is_change_percentage
        -orig-id: isChangePercentage
        type: u1
      - id: is_change_value
        -orig-id: isChangeValue
        type: u1
      - id: is_change_formula
        -orig-id: isChangeFormula
        type: u1
      - id: changing_formula
        -orig-id: changingFormula
        type: sr_str
      - id: must_equal
        -orig-id: mustEqualValues
        type: int_set
      - id: must_mod
        -orig-id: mustModValues
        type: int_set
      - id: crit_text
        -orig-id: critText
        type: sr_str
  jump_qm:
    doc: qmreader.ts parseJump()
    seq:
      - id: priority
        type: f8
      - id: day_passed
        -orig-id: dayPassed
        type: s4
      - id: id
        type: s4
      - id: from_location_id
        -orig-id: fromLocationId
        type: s4
      - id: to_location_id
        -orig-id: toLocationId
        type: s4
      - id: unknown1
        size: 1
      - id: always_show
        -orig-id: alwaysShow
        type: u1
      - id: jumping_count_limit
        -orig-id: jumpingCountLimit
        type: s4
      - id: showing_order
        -orig-id: showingOrder
        type: s4
      - id: params
        type: jump_param_qm
        repeat: expr
        repeat-expr: _root.num_params
      - id: formula_to_pass
        -orig-id: formulaToPass
        type: sr_str
      - id: text
        type: sr_str
      - id: description
        type: sr_str
  jump_condition_qmm:
    seq:
      - id: param_id
        -orig-id: paramId
        type: s4
        doc: 1-based parameter number
      - id: must_from
        -orig-id: mustFrom
        type: s4
      - id: must_to
        -orig-id: mustTo
        type: s4
      - id: must_equal
        -orig-id: mustEqualValues
        type: int_set
      - id: must_mod
        -orig-id: mustModValues
        type: int_set
  jump_qmm:
    doc: qmreader.ts parseJumpQmm()
    seq:
      - id: priority
        type: f8
      - id: day_passed
        -orig-id: dayPassed
        type: s4
      - id: id
        type: s4
      - id: from_location_id
        -orig-id: fromLocationId
        type: s4
      - id: to_location_id
        -orig-id: toLocationId
        type: s4
      - id: always_show
        -orig-id: alwaysShow
        type: u1
      - id: jumping_count_limit
        -orig-id: jumpingCountLimit
        type: s4
      - id: showing_order
        -orig-id: showingOrder
        type: s4
      - id: num_conditions
        -orig-id: affectedConditionsParamsCount
        type: s4
      - id: conditions
        -orig-id: paramsConditions
        type: jump_condition_qmm
        repeat: expr
        repeat-expr: num_conditions
      - id: num_changes
        -orig-id: affectedChangeParamsCount
        type: s4
      - id: changes
        -orig-id: paramsChanges
        type: param_change_qmm
        repeat: expr
        repeat-expr: num_changes
      - id: formula_to_pass
        -orig-id: formulaToPass
        type: sr_str
      - id: text
        type: sr_str
      - id: description
        type: sr_str
      - id: media
        type: media
