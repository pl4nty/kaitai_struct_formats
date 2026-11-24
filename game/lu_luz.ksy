# Imported from https://github.com/lcdr/lu_formats/blob/eb15852181d3fd55f638eb20ce4a2e9cd7f08dac/files/luz.ksy
meta:
  id: lu_luz
  file-extension: luz
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /database/lu_common
  endian: le
seq:
  - id: file_version
    type: u4
  - id: file_revision
    type: u4
    if: file_version >= 36
  - id: zone_id
    type: u4
  - id: player_start_pos
    type: lu_common::vector3
    if: file_version >= 38
  - id: player_start_rot
    type: lu_common::quaternion
    if: file_version >= 38
  - id: num_scene_files
    type:
      switch-on: file_version >= 37
      cases:
        true: u4
        false: u1
  - id: scenes
    type: scene
    repeat: expr
    repeat-expr: num_scene_files
  - id: num_zone_boundary_lines
    type: u1
  - id: boundary_lines
    type: boundary_info
    repeat: expr
    repeat-expr: num_zone_boundary_lines
  - id: raw_filename
    type: lu_common::u1_str
  - id: zone_name
    type: lu_common::u1_str
    if: file_version >= 31
  - id: zone_description
    type: lu_common::u1_str
    if: file_version >= 31
  - id: zone_transition_data
    type: transition_data
    if: file_version >= 32
  - id: path_chunk_size
    type: u4
    if: file_version >= 35
  - id: path_chunk
    size: path_chunk_size
    type: path_chunk
    if: file_version >= 35
types:
  scene:
    seq:
      - id: scene_file_name
        type: lu_common::u1_str
      - id: scene_id
        type: u4
        if: _root.file_version >= 33 or _root.file_version < 30
      - id: layer_id
        type: u4
        if: _root.file_version >= 33
      - id: scene_display_name
        type: lu_common::u1_str
        if: _root.file_version >= 33
      - id: unknown1
        type: lu_common::vector3
        if: _root.file_version == 33
      - id: unknown2
        type: f4
        if: _root.file_version == 33
      - id: scene_color_r
        type: u1
        if: _root.file_version >= 33
      - id: scene_color_g
        type: u1
        if: _root.file_version >= 33
      - id: scene_color_b
        type: u1
        if: _root.file_version >= 33
  boundary_info:
    seq:
      - id: normal
        type: lu_common::vector3
      - id: point
        type: lu_common::vector3
      - id: dest_zone_id
        type: u4
      - id: dest_scene_id
        type: u4
      - id: spawn_loc
        type: lu_common::vector3
  transition_data:
    seq:
      - id: num_transitions
        type: u4
      - id: transitions
        type: transition_info
        repeat: expr
        repeat-expr: num_transitions
  transition_info:
    seq:
      - id: unknown1
        type: lu_common::u1_str
        if: _root.file_version < 40
      - id: unknown2
        type: f4
        if: _root.file_version < 40
      - id: transition_points
        type: transition_point
        repeat: expr
        repeat-expr: "(_root.file_version <= 33 or _root.file_version >= 39) ? 2 : 5"
  transition_point:
    seq:
      - id: scene_id
        type: u4
      - id: layer_id
        type: u4
      - id: transition_point
        type: lu_common::vector3
  path_chunk:
    seq:
      - id: path_chunk_version
        type: u4
      - id: num_paths
        type: u4
      - id: paths
        type: path
        repeat: expr
        repeat-expr: num_paths
  path:
    seq:
      - id: version
        type: u4
      - id: name
        type: lu_common::u1_wstr
      - id: type_name
        type: lu_common::u1_wstr
        if: version <= 2
      - id: type
        type: u4
        enum: path_type
      - id: flags
        type: u4
      - id: behavior
        type: u4
        enum: path_behavior
      - id: data
        type:
          switch-on: type
          cases:
            path_type::platform: platform_data
            path_type::property: property_data
            path_type::camera: camera_data
            path_type::spawner: spawner_data
      - id: num_waypoints
        type: u4
      - id: waypoints
        type: waypoint
        repeat: expr
        repeat-expr: num_waypoints
  platform_data:
    seq:
      - id: traveling_audio_guid
        type: lu_common::u1_wstr
        if: _parent.version >= 13 and _parent.version < 18
      - id: time_based_movement
        type: lu_common::bool
        if: _parent.version >= 18
  property_data:
    seq:
      - id: property_path_type
        type: u4
        enum: property_path_type
      - id: price
        type: u4
      - id: time
        type: u4
      - id: associated_zone
        type: u8
      - id: name
        type: lu_common::u1_wstr
        if: _parent.version >= 5
      - id: description
        type: lu_common::u4_wstr
        if: _parent.version >= 5
      - id: property_type
        type: u4
        enum: property_type
        if: _parent.version >= 6
      - id: clone_limit
        type: u4
        if: _parent.version >= 7
      - id: reputation_multiplier
        type: f4
        if: _parent.version >= 7
      - id: period_type
        type: u4
        if: _parent.version >= 7
      - id: achievement_required
        type: u4
        if: _parent.version >= 8
      - id: zone_position
        type: lu_common::vector3
        if: _parent.version >= 8
      - id: max_build_height
        type: f4
        if: _parent.version >= 8
  camera_data:
    seq:
      - id: next_path
        type: lu_common::u1_wstr
      - id: rotate_player
        type: lu_common::bool
        if: _parent.version >= 14
  spawner_data:
    seq:
      - id: spawned_lot
        type: lu_common::lot
      - id: respawn_time
        type: u4
      - id: max_to_spawn
        type: s4
      - id: num_to_maintain
        type: u4
      - id: object_id
        type: lu_common::object_id
      - id: activate_on_load
        type: lu_common::bool
        if: _parent.version >= 9
  waypoint:
    seq:
      - id: position
        type: lu_common::vector3
      - id: data
        type:
          switch-on: _parent.type
          cases:
            path_type::npc: npc_waypoint_data
            path_type::platform: platform_waypoint_data
            path_type::camera: camera_waypoint_data
            path_type::spawner: spawner_waypoint_data
            path_type::racing: racing_waypoint_data
            path_type::rail: rail_waypoint_data
  npc_waypoint_data:
    seq:
      - id: config
        type: lnv
  platform_waypoint_data:
    seq:
      - id: rotation
        type: lu_common::quaternion_wxyz
      - id: lock_player
        type: lu_common::bool
      - id: speed
        type: f4
      - id: wait
        type: f4
      - id: depart_audio_guid
        type: lu_common::u1_wstr
        if: _parent._parent.version >= 13
      - id: arrive_audio_guid
        type: lu_common::u1_wstr
        if: _parent._parent.version >= 13
  camera_waypoint_data:
    seq:
      - id: rotation
        type: lu_common::quaternion_wxyz
      - id: time
        type: f4
      - id: fov
        type: f4
      - id: tension
        type: f4
      - id: continuity
        type: f4
      - id: bias
        type: f4
  spawner_waypoint_data:
    seq:
      - id: rotation
        type: lu_common::quaternion_wxyz
      - id: config
        type: lnv
  racing_waypoint_data:
    seq:
      - id: rotation
        type: lu_common::quaternion_wxyz
      - id: is_reset_node
        type: lu_common::bool
      - id: is_non_horizontal_camera
        type: lu_common::bool
      - id: plane_width
        type: f4
      - id: plane_height
        type: f4
      - id: shortest_distance_to_end
        type: f4
  rail_waypoint_data:
    seq:
      - id: rotation
        type: lu_common::quaternion_wxyz
      - id: speed
        type: f4
        if: _parent._parent.version > 16
      - id: config
        type: lnv
  lnv:
    seq:
      - id: num_entries
        type: u4
      - id: entries
        type: lnv_entry
        repeat: expr
        repeat-expr: num_entries
  lnv_entry:
    seq:
      - id: name
        type: lu_common::u1_wstr
      - id: type_value
        type: lu_common::u1_wstr
enums:
  path_type:
    0: npc
    1: platform
    2: property
    3: camera
    4: spawner
    5: buildarea
    6: racing
    7: rail
  path_behavior:
    0: loop
    1: bounce
    2: once
  property_path_type:
    0: bounded
    1: entire_zone
    2: generated_rectangle
  property_type:
    0: premiere
    1: prize
    2: lup
    3: headspace
