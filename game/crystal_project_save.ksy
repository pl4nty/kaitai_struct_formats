# Imported from https://github.com/iconmaster5326/CrystalProjector/blob/79320b343d603aa069aa023fd54020d36419e082/schema/ksy/save.ksy
# Licence and copyright: see _community/README.md
meta:
  id: crystal_project_save
  title: Crystal Project save file
  license: MIT
  imports:
    - /common/vlq_base128_le
    - /serialization/bson
  endian: le
doc: |
  A Crystal Project `.sav` save file.
  Note that you have to parse it like a database before parsing it using this
  file;
  it's encrypted in the same way, but is not JSON.
seq:
  - id: ff
    type: u1
    valid: 0xff
    doc: Always 0xff.
  - id: magic1
    type: u4
    doc: Unknown.
  - id: hours_played
    type: u4
    doc: The total number of hours this file has been played.
  - id: minutes_played
    type: u4
    doc: The number of minutes (past the hour) this file has been played.
  - id: seconds_played
    type: u4
    doc: The number of seconds (past the minute) this file has been played.
  - id: magic2
    type: u4
    doc: Unknown.
  - id: year
    type: u4
    doc: The year in which this file was last saved to.
  - id: month
    type: u4
    doc: The month in which this file was last saved to.
  - id: day
    type: u4
    doc: The day in which this file was last saved to.
  - id: minute
    type: u4
    doc: The minute in which this file was last saved to.
  - id: hour
    type: u4
    doc: The hour in which this file was last saved to.
  - id: second
    type: u4
    doc: The second in which this file was last saved to.
  - id: location_name
    type: string
    doc: The name of the last home point you saved at.
  - id: currency
    type: u4
    doc: The amount of currency you have, in terms of copper.
  - id: num_party_members
    type: u4
    doc: How many party members you have. Generally from 1-4.
  - id: party_members
    type: party_member
    repeat: expr
    repeat-expr: num_party_members
    doc: Basic information about party members. See `party_data` for the nitty-gritty.
  - id: magic3
    size: 22
    doc: Unknown.
  - id: num_mods
    type: u4
    doc: How many mods are enabled in this save.
  - id: mods
    type: mod
    repeat: expr
    repeat-expr: num_mods
    doc: Basic information about the mods in this save. Also see `mod_settings`.
  - id: num_mod_settings
    type: u4
    doc: How many mod settings are in this save. Seemingly always equal to `num_mods`.
  - id: mod_settings
    type: mod_settings
    repeat: expr
    repeat-expr: num_mod_settings
    doc: Unknown. Something to do with additional data for each mod. Also see `mods`.
  - id: global_data
    type: bson
    doc: |
      BSON-encoded data for global information, such as inventory contents and flag
      states.
  - id: party_data
    type: bson
    repeat: expr
    repeat-expr: num_party_members
    doc: |
      BSON-encoded data for per-party-member information, such as equipment and job
      progress.
  - id: num_map_data
    type: u4
    doc: How many maps we have uncovered portions of.
  - id: map_data
    type: map_data
    repeat: expr
    repeat-expr: num_map_data
    doc: Map visibility information.
  - id: magic4
    type: u4
    doc: Unknown.
  - id: len_magic5
    type: u4
    doc: How long `magic5` is, in bytes.
  - id: magic5
    size: len_magic5
    doc: Unknown.
  - id: len_logs
    type: u4
    doc: Always equal to `logs.len_zipfile` plus 4. If 0, there are no logfiles.
  - id: logs
    type: logs
    if: len_logs > 0
    doc: The logging file.
types:
  string:
    doc: A string.
    seq:
      - id: length
        type: vlq_base128_le
        doc: How long is this string?
      - id: value
        size: length.value
        type: str
        encoding: UTF-8
        doc: The string.
  nullable_string:
    doc: A boolean byte followed by a length-terminated string.
    seq:
      - id: has_value
        type: u1
        valid:
          any-of: [0, 1]
        doc: Does this string exist?
      - id: string
        type: string
        if: has_value == 1
        doc: The string, only if has_value is 1.
  party_member:
    doc: Basic information on a single party member.
    seq:
      - id: name
        type: nullable_string
        doc: The party member's name.
      - id: level
        type: u4
        doc: The party member's level.
      - id: gender
        type: u4
        doc: The ID of the party member's gender.
      - id: job
        type: u4
        doc: The ID of the party member's job.
  mod:
    doc: Basic information about a mod that's needed to load this save.
    seq:
      - id: uuid
        type: string
        doc: The UUID of the mod.
      - id: name
        type: string
        doc: The name of the mod.
      - id: version
        type: string
        doc: The semantic version of the mod.
      - id: magic1
        size: 8
        doc: Unknown.
  mod_settings:
    doc: Unknown. Something to do with storing some mod data.
    seq:
      - id: uuid
        type: string
        doc: The UUID of the mod.
      - id: num_entries
        type: u4
        doc: Unknown.
      - id: entries
        size: 16
        repeat: expr
        repeat-expr: num_entries
        doc: Unknown.
      - id: magic2
        size: 56
        doc: Unknown.
  map_data:
    seq:
      - id: biome
        type: u4
        doc: The biome ID the map belongs to.
      - id: pos_x
        type: s4
        doc: The map's X position.
      - id: pos_z
        type: s4
        doc: The map's Z position.
      - id: size_x
        type: u4
        doc: The map's width.
      - id: size_z
        type: u4
        doc: The map's height.
      - id: len_map_pixels_uncovered
        type: u4
        doc: How many pixels do we have? Usually, equal to `ceil(size_x * size_z / 8)`.
      - id: map_pixels_uncovered
        size: len_map_pixels_uncovered
        doc: |
          What pixels are uncovered in this map? An array of packed bits, with a number of
          bits equal to the width times the height.
  logs:
    doc: Logging information.
    seq:
      - id: len_zipfile
        type: u4
        doc: How long is the ZIP file below, in bytes?
      - id: zipfile
        size: len_zipfile
        doc: A ZIP file that contains exactly one `.dat` file, `log.dat`.
