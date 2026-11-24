meta:
  id: mapsforge_map
  title: Mapsforge binary map file
  application:
    - Mapsforge
    - OruxMaps
    - Locus Map
  file-extension: map
  license: CC0-1.0
  ks-version: '0.11'
  imports:
    - /common/vlq_base128_le
  encoding: UTF-8
  endian: be
doc: |
  Vector map format of the mapsforge library, used to render OpenStreetMap data
  on mobile devices. The file is made of a header followed by one sub-file per
  zoom interval; each sub-file consists of a tile index (one 5-byte entry per
  tile of the bounding box at the sub-file's base zoom level, row by row) and
  the tile data.

  This spec covers the file header, the zoom interval configuration, the tile
  index of every sub-file and the tile headers (optional debug signature, zoom
  table and first way offset). The POI and way records inside each tile are
  exposed as raw bytes: since format version 5, tags may carry variable values
  whose types can only be derived from the wildcards in the tag names of the
  header, and coordinates are stored as sign-magnitude variable-length integers
  (VBE-S), which makes these records impractical to describe declaratively.

  The number of tile index entries is normally computed by readers from the
  bounding box (which needs the Mercator projection, not expressible here).
  This spec instead derives it from the first index entry: tile data starts
  right after the index, so the first tile's offset equals the size of the
  index (including the optional 16-byte debug signature).

  All latitude and longitude values are in microdegrees.
doc-ref:
  - https://github.com/mapsforge/mapsforge/blob/f136dce0d3c02f25cf50fb79001d31db7fb08b21/docs/Specification-Binary-Map-File.md
  - https://github.com/mapsforge/mapsforge/blob/f136dce0d3c02f25cf50fb79001d31db7fb08b21/mapsforge-map-reader/src/main/java/org/mapsforge/map/reader/MapFile.java
seq:
  - id: magic
    contents: mapsforge binary OSM
  - id: len_header
    type: u4
    doc: Size of the file header, not counting `magic` and this field.
  - id: header
    size: len_header
    type: header
instances:
  sub_files:
    type: sub_file_ref(_index)
    repeat: expr
    repeat-expr: header.num_zoom_intervals
types:
  header:
    seq:
      - id: file_version
        type: u4
        doc: 3 to 5 are known.
      - id: file_size
        type: u8
      - id: date_of_creation
        type: s8
        doc: Milliseconds since 1970-01-01.
      - id: min_lat
        type: s4
      - id: min_lon
        type: s4
      - id: max_lat
        type: s4
      - id: max_lon
        type: s4
      - id: tile_size
        type: u2
        doc: Tile size in pixels (e.g. 256).
      - id: projection
        type: vbe_string
        doc: Always `Mercator`.
      - id: flags
        type: header_flags
      - id: map_start_lat
        type: s4
        if: flags.has_start_position
      - id: map_start_lon
        type: s4
        if: flags.has_start_position
      - id: start_zoom_level
        type: u1
        if: flags.has_start_zoom_level
      - id: languages_preference
        type: vbe_string
        if: flags.has_languages_preference
        doc: Comma-separated ISO 639-1/639-2 language codes.
      - id: comment
        type: vbe_string
        if: flags.has_comment
      - id: created_by
        type: vbe_string
        if: flags.has_created_by
      - id: num_poi_tags
        type: u2
      - id: poi_tags
        type: vbe_string
        repeat: expr
        repeat-expr: num_poi_tags
        doc: '`key=value` strings; tag IDs are the indices in this list.'
      - id: num_way_tags
        type: u2
      - id: way_tags
        type: vbe_string
        repeat: expr
        repeat-expr: num_way_tags
        doc: '`key=value` strings; tag IDs are the indices in this list.'
      - id: num_zoom_intervals
        type: u1
      - id: zoom_intervals
        type: zoom_interval
        repeat: expr
        repeat-expr: num_zoom_intervals
  header_flags:
    seq:
      - id: is_debug
        type: b1
        doc: Signatures are present in index, tiles, POIs and ways.
      - id: has_start_position
        type: b1
      - id: has_start_zoom_level
        type: b1
      - id: has_languages_preference
        type: b1
      - id: has_comment
        type: b1
      - id: has_created_by
        type: b1
      - id: reserved
        type: b2
  zoom_interval:
    seq:
      - id: base_zoom_level
        type: u1
      - id: min_zoom_level
        type: u1
      - id: max_zoom_level
        type: u1
      - id: ofs_sub_file
        type: u8
        doc: Absolute position of the sub-file.
      - id: len_sub_file
        type: u8
  vbe_string:
    seq:
      - id: len_value
        type: vlq_base128_le
      - id: value
        size: len_value.value
        type: str
  sub_file_ref:
    params:
      - id: idx
        type: u1
    instances:
      zoom_interval:
        value: _root.header.zoom_intervals[idx]
      body:
        io: _root._io
        pos: zoom_interval.ofs_sub_file
        size: zoom_interval.len_sub_file
        type: sub_file(zoom_interval.max_zoom_level - zoom_interval.min_zoom_level + 1)
  sub_file:
    params:
      - id: num_zoom_levels
        type: u1
    seq:
      - id: index_signature
        contents: +++IndexStart+++
        if: _root.header.flags.is_debug
      - id: index_entries
        type: index_entry
        repeat: expr
        repeat-expr: num_index_entries
      - id: tiles
        type: tile_ref(_index)
        repeat: expr
        repeat-expr: index_entries.size
    instances:
      len_index_signature:
        value: '_root.header.flags.is_debug ? 16 : 0'
      first_index_entry:
        pos: len_index_signature
        type: index_entry
      num_index_entries:
        value: (first_index_entry.ofs_tile - len_index_signature) / 5
  index_entry:
    seq:
      - id: is_water
        type: b1
        doc: The tile is completely covered by water.
      - id: ofs_tile
        type: b39
        doc: |
          Offset of the tile data relative to the start of the sub-file. An empty
          tile has the same offset as the next one.
  tile_ref:
    params:
      - id: idx
        type: s4
    instances:
      ofs_tile:
        value: _parent.index_entries[idx].ofs_tile
      ofs_next_tile:
        value: '(idx + 1 < _parent.num_index_entries) ? _parent.index_entries[idx + 1].ofs_tile : _parent._io.size'
      is_empty:
        value: ofs_next_tile == ofs_tile
      body:
        io: _parent._io
        pos: ofs_tile
        size: ofs_next_tile - ofs_tile
        type: tile(_parent.num_zoom_levels)
        if: not is_empty
  tile:
    params:
      - id: num_zoom_levels
        type: u1
    seq:
      - id: signature
        size: 32
        type: str
        if: _root.header.flags.is_debug
        doc: '`###TileStartX,Y###`, padded with spaces.'
      - id: zoom_levels
        -orig-id: zoom table
        type: zoom_table_row
        repeat: expr
        repeat-expr: num_zoom_levels
        doc: |
          One row per zoom level of the sub-file, starting with the minimal one.
          The number of POIs/ways to render at a zoom level is the sum of the
          values in the rows up to and including that level.
      - id: ofs_first_way
        type: vlq_base128_le
        doc: Size of the POI data, i.e. offset of the first way after this field.
      - id: pois
        size: ofs_first_way.value
      - id: ways
        size-eos: true
  zoom_table_row:
    seq:
      - id: num_pois
        type: vlq_base128_le
      - id: num_ways
        type: vlq_base128_le
