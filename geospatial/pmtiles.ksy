# Imported from https://github.com/yskmasumoto/kaitai-pmtiles/blob/237db1c3b8d31fb95d43f34b205ca321caecba0f/ksy/pmtiles.ksy
# Licence and copyright: see _community/README.md
meta:
  id: pmtiles
  title: PMTiles version 3
  file-extension: pmtiles
  license: MIT
  endian: le

seq:
  - id: header
    type: header

instances:
  root_directory_raw:
    pos: header.root_dir_offset
    size: header.root_dir_length

# ここに全てのカスタム型をまとめます
types:
  header:
    seq:
      - id: signature
        contents: "PMTiles"
      - id: spec_version
        type: u1
      - id: root_dir_offset
        type: u8
      - id: root_dir_length
        type: u8
      - id: metadata_offset
        type: u8
      - id: metadata_length
        type: u8
      - id: leaf_directories_offset
        type: u8
      - id: leaf_directories_length
        type: u8
      - id: tile_data_offset
        type: u8
      - id: tile_data_length
        type: u8
      - id: addressed_tiles_count
        type: u8
      - id: tile_entries_count
        type: u8
      - id: tile_contents_count
        type: u8
      - id: clustered
        type: u1
      - id: internal_compression
        type: u1
        enum: compression
      - id: tile_compression
        type: u1
        enum: compression
      - id: tile_type
        type: u1
        enum: tile_type
      - id: min_zoom
        type: u1
      - id: max_zoom
        type: u1
      - id: min_lon_e7
        type: s4
      - id: min_lat_e7
        type: s4
      - id: max_lon_e7
        type: s4
      - id: max_lat_e7
        type: s4
      - id: center_zoom
        type: u1
      - id: center_lon_e7
        type: s4
      - id: center_lat_e7
        type: s4

  # vlq_base128_le も types の一段下に配置します
  vlq_base128_le:
    seq:
      - id: groups
        type: u1
        repeat: until
        repeat-until: _ & 0x80 == 0
    instances:
      value:
        value: >-
          (groups.size > 0 ? (groups[0] & 0x7f) : 0) |
          (groups.size > 1 ? (groups[1] & 0x7f) << 7 : 0) |
          (groups.size > 2 ? (groups[2] & 0x7f) << 14 : 0) |
          (groups.size > 3 ? (groups[3] & 0x7f) << 21 : 0) |
          (groups.size > 4 ? (groups[4] & 0x7f) << 28 : 0) |
          (groups.size > 5 ? (groups[5] & 0x7f) << 35 : 0) |
          (groups.size > 6 ? (groups[6] & 0x7f) << 42 : 0) |
          (groups.size > 7 ? (groups[7] & 0x7f) << 49 : 0)

  directory:
    seq:
      - id: n_entries
        type: vlq_base128_le
      - id: tile_id_deltas
        type: vlq_base128_le
        repeat: expr
        repeat-expr: n_entries.value
      - id: run_lengths
        type: vlq_base128_le
        repeat: expr
        repeat-expr: n_entries.value
      - id: lengths
        type: vlq_base128_le
        repeat: expr
        repeat-expr: n_entries.value
      - id: offset_deltas
        type: vlq_base128_le
        repeat: expr
        repeat-expr: n_entries.value

enums:
  compression:
    0: none
    1: unknown
    2: gzip
    3: brotli
    4: zstd
  tile_type:
    0: unknown
    1: mvt
    2: png
    3: jpeg
    4: webp
    5: avif
