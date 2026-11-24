meta:
  id: andors_trail_savegame
  title: Andor's Trail savegame
  application: Andor's Trail
  license: CC0-1.0
  ks-version: '0.11'
  endian: be
doc: |
  Savegame of Andor's Trail, an open-source role-playing game for Android.
  Savegames are stored in the `andors-trail` directory of the external
  storage as `savegame<slot>` (the quicksave as `savegame` in the app's
  private storage), without a file extension. They are written with a
  Java `DataOutputStream`, so all numbers are big-endian and strings are
  stored as a 16-bit length followed by modified UTF-8.

  This spec covers the file header that the game reads to show the list of
  saved games: format version, player name, display info and (since format
  version 43) the player icon. The rest of the file (the state of all maps
  followed by the model: player, quests, ...) is serialized by many classes
  with per-version differences and is left raw in `body`.

  Savegames older than format version 14 (game version 0.6.7) have no
  header; for them `version` is already part of the game state.
doc-ref:
  - https://github.com/Zukero/andors-trail/blob/495b48cbf8bb8aae2c0234c7c74c62286541f63f/AndorsTrail/src/com/gpl/rpg/AndorsTrail/savegames/Savegames.java
  - https://github.com/Zukero/andors-trail/blob/495b48cbf8bb8aae2c0234c7c74c62286541f63f/AndorsTrail/src/com/gpl/rpg/AndorsTrail/resource/tiles/TileManager.java
seq:
  - id: version
    -orig-id: fileversion
    type: s4
    doc: |
      Savegame format version (47 for game version 0.7.6). The game treats
      the value 11 as format version 5, which had no version field.
  - id: player_name
    type: java_utf
    if: version >= 14
  - id: display_info
    type: java_utf
    if: version >= 14
    doc: Description shown in the list of savegames (level, location, ...).
  - id: icon_id
    -orig-id: iconID
    type: s4
    if: has_icon
    doc: Player icon, 1 to 3.
  - id: body
    size-eos: true
    doc: Maps state followed by the model state.
instances:
  ofs_icon:
    value: '4 + (version >= 14 ? 2 + player_name.len_value + 2 + display_info.len_value : 0)'
  icon_id_peek:
    pos: ofs_icon
    type: s4
    if: version >= 43
  has_icon:
    value: version >= 43 and icon_id_peek <= 3
    doc: |
      The game reads the icon only from format version 43 on. A value
      greater than the last hero icon (3) is not an icon: the game then
      reads the following data from that position.
types:
  java_utf:
    seq:
      - id: len_value
        type: u2
      - id: value
        size: len_value
        type: str
        encoding: UTF-8
        doc: Modified UTF-8 (NUL as 0xC0 0x80, supplementary characters as surrogate pairs).
