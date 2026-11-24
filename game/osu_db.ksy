meta:
  id: osu_db
  title: osu! beatmap database (osu!.db)
  application: osu!
  file-extension: db
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /common/vlq_base128_le
  encoding: UTF-8
  endian: le
doc: |
  `osu!.db` is the cache that the "stable" client of the rhythm game osu!
  keeps about all installed beatmaps. It lives in the installation
  directory of the game, which rebuilds the file if it is deleted.

  The layout depends on the version of the client that wrote the file,
  stored as a date in the first field.
doc-ref: https://github.com/ppy/osu/wiki/Legacy-database-file-structure
seq:
  - id: version
    type: u4
    doc: Version of osu! as a decimal date, e.g. 20150203.
  - id: num_folders
    type: u4
  - id: is_account_unlocked
    type: u1
    doc: 0 only if the account is locked or banned.
  - id: account_unlock_date
    type: date_time
  - id: player_name
    type: string
  - id: num_beatmaps
    type: u4
  - id: beatmaps
    type: beatmap
    repeat: expr
    repeat-expr: num_beatmaps
  - id: user_permissions
    type: u4
    doc: |
      Bit mask: 1 = normal, 2 = moderator, 4 = supporter, 8 = friend,
      16 = peppy, 32 = World Cup staff.
types:
  string:
    seq:
      - id: is_present
        type: u1
        doc: 0x0b if a string follows, 0 if not.
      - id: len_value
        type: vlq_base128_le
        if: is_present == 0x0b
      - id: value
        size: len_value.value
        type: str
        if: is_present == 0x0b
  date_time:
    seq:
      - id: ticks
        type: u8
        doc: |
          Number of 100-nanosecond intervals since midnight of January 1st
          of the year 1, as in the .NET `DateTime` type.
  int_float_pair:
    seq:
      - id: int_marker
        contents: [0x08]
      - id: mods
        type: u4
        doc: Combination of mods.
      - id: float_marker
        contents: [0x0c]
      - id: star_rating
        type: f4
  int_double_pair:
    seq:
      - id: int_marker
        contents: [0x08]
      - id: mods
        type: u4
        doc: Combination of mods.
      - id: double_marker
        contents: [0x0d]
      - id: star_rating
        type: f8
  star_ratings:
    seq:
      - id: num_pairs
        type: u4
      - id: pairs
        type:
          switch-on: _root.version < 20250107
          cases:
            true: int_double_pair
            false: int_float_pair
        repeat: expr
        repeat-expr: num_pairs
  timing_point:
    seq:
      - id: bpm
        type: f8
      - id: offset
        type: f8
        doc: Offset into the song, in milliseconds.
      - id: is_uninherited
        type: u1
        doc: 0 if this timing point is inherited.
  beatmap:
    seq:
      - id: len_entry
        type: u4
        if: _root.version < 20191106
        doc: Size of the beatmap entry in bytes.
      - id: artist_name
        type: string
      - id: artist_name_unicode
        type: string
      - id: song_title
        type: string
      - id: song_title_unicode
        type: string
      - id: creator_name
        type: string
      - id: difficulty
        type: string
        doc: Name of the difficulty, e.g. Hard or Insane.
      - id: audio_file_name
        type: string
      - id: md5_hash
        type: string
        doc: MD5 hash of the beatmap, as hexadecimal text.
      - id: osu_file_name
        type: string
        doc: Name of the .osu file of the beatmap.
      - id: ranked_status
        type: u1
        enum: ranked_status
      - id: num_hitcircles
        type: u2
      - id: num_sliders
        type: u2
      - id: num_spinners
        type: u2
      - id: last_modification_time
        type: date_time
      - id: approach_rate
        type:
          switch-on: _root.version < 20140609
          cases:
            true: u1
            false: f4
      - id: circle_size
        type:
          switch-on: _root.version < 20140609
          cases:
            true: u1
            false: f4
      - id: hp_drain
        type:
          switch-on: _root.version < 20140609
          cases:
            true: u1
            false: f4
      - id: overall_difficulty
        type:
          switch-on: _root.version < 20140609
          cases:
            true: u1
            false: f4
      - id: slider_velocity
        type: f8
      - id: star_ratings
        type: star_ratings
        repeat: expr
        repeat-expr: 4
        if: _root.version >= 20140609
        doc: |
          Star ratings per combination of mods, for each of the game modes
          in the order of the `gameplay_mode` enum.
      - id: drain_time
        type: u4
        doc: In seconds.
      - id: total_time
        type: u4
        doc: In milliseconds.
      - id: audio_preview_start_time
        type: u4
        doc: In milliseconds.
      - id: num_timing_points
        type: u4
      - id: timing_points
        type: timing_point
        repeat: expr
        repeat-expr: num_timing_points
      - id: difficulty_id
        type: u4
      - id: beatmap_id
        type: u4
      - id: thread_id
        type: u4
      - id: grades
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: |
          Grade achieved in each of the game modes, in the order of the
          `gameplay_mode` enum.
      - id: local_offset
        type: u2
      - id: stack_leniency
        type: f4
      - id: gameplay_mode
        type: u1
        enum: gameplay_mode
      - id: song_source
        type: string
      - id: song_tags
        type: string
      - id: online_offset
        type: u2
      - id: title_font
        type: string
      - id: is_unplayed
        type: u1
      - id: last_played_time
        type: date_time
      - id: is_osz2
        type: u1
      - id: folder_name
        type: string
        doc: Relative to the Songs folder.
      - id: last_checked_time
        type: date_time
        doc: Last time the beatmap was checked against the osu! repository.
      - id: ignores_beatmap_sound
        type: u1
      - id: ignores_beatmap_skin
        type: u1
      - id: is_storyboard_disabled
        type: u1
      - id: is_video_disabled
        type: u1
      - id: has_visual_override
        type: u1
      - id: unknown
        type: u2
        if: _root.version < 20140609
      - id: last_modification_time2
        type: u4
      - id: mania_scroll_speed
        type: u1
enums:
  ranked_status:
    0: unknown
    1: unsubmitted
    2: pending
    3: unused
    4: ranked
    5: approved
    6: qualified
    7: loved
  gameplay_mode:
    0: osu
    1: taiko
    2: catch
    3: mania
