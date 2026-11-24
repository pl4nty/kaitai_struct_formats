meta:
  id: rpgmaker_lcf
  title: RPG Maker 2000/2003 LCF data file (database, map, save)
  application:
    - RPG Maker 2000
    - RPG Maker 2003
    - EasyRPG
  file-extension:
    - ldb
    - lmu
    - lsd
  license: CC0-1.0
  ks-version: '0.9'
  imports:
    - /common/vlq_base128_be
doc: |
  LCF is the binary data format of RPG Maker 2000 and 2003: the database
  (`RPG_RT.ldb`), maps (`Map0001.lmu`, ...) and save games (`Save01.lsd`,
  ...).

  A file starts with a header string (`LcfDataBase`, `LcfMapUnit` or
  `LcfSaveData`) prefixed with its length. The rest is a structure: a list
  of chunks, each with an ID, the size of its data and the data. Integers,
  including chunk IDs and sizes, are stored as variable-length big-endian
  base-128 numbers. A structure normally ends with a chunk ID of 0, but the
  top-level structures of a database and of a save game just end at the end
  of the file.

  Chunk data is either a scalar (an integer, flag, string or vector), a
  nested structure (a chunk list ending with ID 0), or an array of
  structures. This spec parses the header, the top-level chunks with their
  IDs named after liblcf, and the nested structures directly under the top
  level (e.g. the database terms and system data, or the save game title
  and system data); all other chunk data is exposed raw.

  The map tree file (`RPG_RT.lmt`, header `LcfMapTree`) uses a different
  top-level layout and is not covered.
doc-ref:
  - https://github.com/EasyRPG/liblcf/blob/6854310c3432e553fd4ae672ce861899c80c3bd0/generator/csv/fields.csv
  - https://github.com/EasyRPG/liblcf/blob/6854310c3432e553fd4ae672ce861899c80c3bd0/src/reader_lcf.cpp
  - https://github.com/EasyRPG/liblcf/blob/6854310c3432e553fd4ae672ce861899c80c3bd0/src/reader_struct_impl.h
  - https://github.com/EasyRPG/liblcf/blob/6854310c3432e553fd4ae672ce861899c80c3bd0/src/ldb_reader.cpp
  - https://github.com/EasyRPG/liblcf/blob/6854310c3432e553fd4ae672ce861899c80c3bd0/src/lmu_reader.cpp
  - https://github.com/EasyRPG/liblcf/blob/6854310c3432e553fd4ae672ce861899c80c3bd0/src/lsd_reader.cpp
seq:
  - id: len_header
    type: vlq_base128_be
  - id: header
    size: len_header.value
    type: str
    encoding: ASCII
    valid:
      any-of: ['"LcfDataBase"', '"LcfMapUnit"', '"LcfSaveData"']
  - id: chunks
    type: top_level_chunk
    repeat: until
    repeat-until: _io.eof or _.is_end
instances:
  is_database:
    value: header == "LcfDataBase"
  is_map:
    value: header == "LcfMapUnit"
  is_save:
    value: header == "LcfSaveData"
types:
  top_level_chunk:
    seq:
      - id: id
        type: vlq_base128_be
      - id: len_data
        type: vlq_base128_be
        if: not is_end
      - id: data
        size: len_data.value
        type:
          switch-on: is_struct
          cases:
            true: chunk_list
        if: not is_end
    instances:
      is_end:
        value: id.value == 0
      database_id:
        value: id.value
        enum: database_chunk
        if: _root.is_database
      map_id:
        value: id.value
        enum: map_chunk
        if: _root.is_map
      save_id:
        value: id.value
        enum: save_chunk
        if: _root.is_save
      is_struct:
        value: |
          _root.is_database ? (id.value == 0x15 or id.value == 0x16 or id.value == 0x1d)
            : _root.is_save ? (id.value >= 0x64 and id.value <= 0x71 and id.value != 0x67 and id.value != 0x6c and id.value != 0x6e)
            : false
        doc: |
          True if the data is a nested structure (chunk list). Chunks with
          an ID not known to liblcf are left raw.
  chunk_list:
    doc: A structure, as a list of chunks ending with a chunk ID of 0.
    seq:
      - id: chunks
        type: chunk
        repeat: until
        repeat-until: _io.eof or _.is_end
  chunk:
    seq:
      - id: id
        type: vlq_base128_be
      - id: len_data
        type: vlq_base128_be
        if: not is_end
      - id: data
        size: len_data.value
        if: not is_end
    instances:
      is_end:
        value: id.value == 0
enums:
  database_chunk:
    0x0b: actors
    0x0c: skills
    0x0d: items
    0x0e: enemies
    0x0f: troops
    0x10: terrains
    0x11: attributes
    0x12: states
    0x13: animations
    0x14: chipsets
    0x15: terms
    0x16: system
    0x17: switches
    0x18: variables
    0x19: common_events
    0x1a: version
    0x1b: common_event_d2
    0x1c: common_event_d3
    0x1d: battle_commands
    0x1e: classes
    0x1f: class_d1
    0x20: battler_animations
  map_chunk:
    0x01: chipset_id
    0x02: width
    0x03: height
    0x0b: scroll_type
    0x1f: parallax_flag
    0x20: parallax_name
    0x21: parallax_loop_x
    0x22: parallax_loop_y
    0x23: parallax_auto_loop_x
    0x24: parallax_sx
    0x25: parallax_auto_loop_y
    0x26: parallax_sy
    0x28: generator_flag
    0x29: generator_mode
    0x2a: top_level
    0x30: generator_tiles
    0x31: generator_width
    0x32: generator_height
    0x33: generator_surround
    0x34: generator_upper_wall
    0x35: generator_floor_b
    0x36: generator_floor_c
    0x37: generator_extra_b
    0x38: generator_extra_c
    0x3c: generator_x
    0x3d: generator_y
    0x3e: generator_tile_ids
    0x47: lower_layer
    0x48: upper_layer
    0x51: events
    0x5a: save_count_2k3e
    0x5b: save_count
  save_chunk:
    0x64: title
    0x65: system
    0x66: screen
    0x67: pictures
    0x68: party_location
    0x69: boat_location
    0x6a: ship_location
    0x6b: airship_location
    0x6c: actors
    0x6d: inventory
    0x6e: targets
    0x6f: map_info
    0x70: panorama
    0x71: foreground_event_execstate
    0x72: common_events
