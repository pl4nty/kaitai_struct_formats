meta:
  id: delorme_an1
  title: DeLorme drawing file (.an1)
  application:
    - DeLorme Street Atlas USA
    - DeLorme Topo USA
    - GPSBabel
  file-extension: an1
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Drawing layer of DeLorme's desktop mapping software (Street Atlas USA,
  Topo USA and others): symbols, map notes, text, circles and images placed
  on the map ("waypoints"), and lines such as roads, trails and tracks.

  The file is a short header, a table of symbol definitions interleaved
  with bitmaps used by them, the list of waypoints, and the list of lines,
  each with its vertices. Coordinates are 32-bit integers in units of
  1/0x800000 degree, offset by 0x80000000.

  The format is undocumented; this spec follows the reader in GPSBabel,
  and most fields are of unknown meaning. Strings are in the Windows ANSI
  code page.
doc-ref:
  - https://github.com/gpsbabel/gpsbabel/blob/e1e195beca8e0f24ca0e41c02d1986af13865cd0/an1.cc
  - https://github.com/gpsbabel/gpsbabel/blob/e1e195beca8e0f24ca0e41c02d1986af13865cd0/xmldoc/formats/an1.xml
seq:
  - id: magic
    contents: [0x25, 0x2d]
    doc: 11557 as a 16-bit integer.
  - id: file_type
    type: u2
    enum: file_type
  - id: num_symbols
    type: u4
  - id: symbol_table
    type: 'symbol_table_record(_index == 0 ? num_symbols : symbol_table[_index - 1].num_symbols_left)'
    repeat: until
    repeat-until: _.num_symbols_left == 0
    if: num_symbols != 0
    doc: Symbols, with the bitmaps and image lists they use in between.
  - id: unknown1
    type: u2
  - id: num_waypoints
    type: u4
  - id: waypoints
    type: waypoint
    repeat: expr
    repeat-expr: num_waypoints
  - id: unknown2
    type: u2
  - id: num_lines
    type: u4
  - id: lines
    type: line
    repeat: expr
    repeat-expr: num_lines
types:
  symbol_table_record:
    params:
      - id: num_symbols_before
        type: u4
        doc: Number of symbols still to be read before this record.
    seq:
      - id: kind
        type: u2
        doc: |
          `BM` for a bitmap, `IL` for an image list; anything else is the low 16 bits
          of the hotspot X coordinate of a symbol.
      - id: body
        type:
          switch-on: kind
          cases:
            0x4d42: bitmap
            0x4c49: image_list
            _: symbol
    instances:
      is_symbol:
        value: kind != 0x4d42 and kind != 0x4c49
      num_symbols_left:
        value: 'is_symbol ? num_symbols_before - 1 : num_symbols_before'
  bitmap:
    doc: |
      A Windows bitmap file (including its `BM` signature, already read), with
      a BITMAPINFOHEADER, as read by GPSBabel.
    seq:
      - id: len_file
        type: u4
      - id: reserved
        size: 4
      - id: ofs_bits
        type: u4
        doc: Offset of the pixel data from the start of the bitmap.
      - id: len_info_header
        type: u4
      - id: info_header_fields
        size: 16
        doc: Width, height, planes, bit count and compression.
      - id: len_image
        type: u4
      - id: info_header_fields2
        size: 16
        doc: Resolution and color counts.
      - id: palette_and_bits
        size: ofs_bits - len_info_header - 14 + len_image
  image_list:
    seq:
      - id: unknown
        size: 26
  symbol:
    seq:
      - id: hotspot_x_hi
        type: u2
        doc: High 16 bits of the hotspot X coordinate.
      - id: hotspot_y
        type: u4
      - id: unknown1
        type: u4
      - id: guid
        size: 16
        doc: Identifies the symbol; waypoints refer to it.
      - id: len_name
        type: u1
      - id: name
        size: len_name
        type: str
        encoding: windows-1252
  waypoint:
    seq:
      - id: magic
        type: u2
      - id: unknown1
        type: u4
      - id: lon_raw
        type: u4
      - id: lat_raw
        type: u4
      - id: waypoint_type
        type: u2
        enum: waypoint_type
      - id: height
        type: s4
      - id: width
        type: s4
      - id: unknown2
        type: u2
      - id: unknown3
        type: u2
      - id: serial
        type: u2
      - id: unknown4
        type: u2
      - id: create_zoom
        type: u1
      - id: visible_zoom
        type: u1
      - id: unknown5
        type: u2
      - id: radius
        type: f8
        doc: Radius of a circle, in kilometers.
      - id: len_name_record
        type: u2
      - id: name_record
        size: len_name_record
        type: name_record
      - id: len_image_fields
        type: u2
        if: waypoint_type == waypoint_type::image
        doc: Total length of the font name and image name fields.
      - id: len_font_name
        type: u2
      - id: font_name
        size: len_font_name
        type: str
        encoding: windows-1252
      - id: len_image_name
        type: u2
        if: waypoint_type == waypoint_type::image
      - id: image_name
        size: len_image_name
        type: str
        encoding: windows-1252
        if: waypoint_type == waypoint_type::image
        doc: Path of the image file shown by an image waypoint.
      - id: symbol_guid
        size: 16
        doc: GUID of the symbol of the waypoint.
      - id: font_color
        type: u4
      - id: font_style
        type: u4
      - id: font_size
        type: u4
      - id: outline_weight
        type: u4
      - id: outline_color
        type: u4
      - id: outline_flags
        type: u4
      - id: fill_color
        type: u4
        doc: Color as 0x00BBGGRR.
      - id: unknown6
        type: u4
      - id: fill_flags
        type: u4
    instances:
      latitude:
        value: (2147483648.0 - lat_raw) / 8388608.0
        doc: Latitude in degrees.
      longitude:
        value: (lon_raw - 2147483648.0) / 8388608.0
        doc: Longitude in degrees.
  name_record:
    doc: |
      Name (description) of the waypoint. Files written by Street Atlas 2006 /
      Topo 6.0 and later append further fields after the terminating NUL byte,
      for backward compatibility.
    seq:
      - id: name
        type: strz
        eos-error: false
        encoding: windows-1252
        doc: Older files do not terminate the name with a NUL byte.
      - id: unknown1
        type: u2
        if: not _io.eof
      - id: len_url
        type: u2
        if: not _io.eof
      - id: url
        size: len_url
        type: str
        encoding: windows-1252
        if: not _io.eof
      - id: len_comment
        type: u2
        if: not _io.eof
      - id: comment
        size: len_comment
        type: str
        encoding: windows-1252
        if: not _io.eof
      - id: creation_time
        type: u8
        if: not _io.eof
        doc: Unix time.
      - id: modification_time
        type: u8
        if: not _io.eof
        doc: Unix time.
  line:
    seq:
      - id: road_type
        type: u4
      - id: serial
        type: u2
      - id: unknown2
        type: u4
      - id: unknown3
        type: u2
      - id: line_type
        type: u2
      - id: unknown4
        type: u4
      - id: len_name
        type: u2
      - id: name
        size: len_name
        type: str
        encoding: windows-1252
      - id: line_weight
        type: u2
        doc: Width of the line; 0 for dashed and dotted lines.
      - id: line_style
        type: u4
      - id: line_color
        type: u4
        doc: Color as 0x00BBGGRR.
      - id: opacity
        type: u4
        doc: 0x8200 for a half-transparent line.
      - id: poly_fill_color
        type: u4
      - id: unknown6
        type: u4
      - id: unknown7
        type: u4
      - id: unknown8
        type: u2
      - id: num_vertices
        type: u4
      - id: vertices
        type: vertex
        repeat: expr
        repeat-expr: num_vertices
  vertex:
    seq:
      - id: magic
        type: u2
      - id: unknown0
        type: u4
      - id: lon_raw
        type: u4
      - id: lat_raw
        type: u4
      - id: unknown1
        type: u2
    instances:
      latitude:
        value: (2147483648.0 - lat_raw) / 8388608.0
        doc: Latitude in degrees.
      longitude:
        value: (lon_raw - 2147483648.0) / 8388608.0
        doc: Longitude in degrees.
enums:
  file_type:
    0: drawing
    1: road
    2: trail
    3: waypoint
    4: track
  waypoint_type:
    1: symbol
    4: text
    5: circle
    6: map_note
    18: image
