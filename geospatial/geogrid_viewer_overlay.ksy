meta:
  id: geogrid_viewer_overlay
  title: Geogrid-Viewer binary overlay (versions 2.0, 3.0, 4.0)
  application:
    - Geogrid-Viewer
    - GPSBabel
  file-extension: ovl
  license: CC0-1.0
  ks-version: '0.9'
  encoding: ISO-8859-1
  endian: le
doc: |
  Binary overlay files used by Geogrid-Viewer, which is part of the Top50
  map products available in Germany and Austria. An overlay holds drawing
  objects placed on the map: text labels, lines (tracks), areas, simple
  geometric shapes and bitmaps. Coordinates are stored as little-endian
  doubles, longitude first.

  Formats 2.0, 3.0 and 4.0 are covered (3.0 and 4.0 share the same
  layout); version 5.0 is not. Most property fields have no known meaning
  and are named after the corresponding GPSBabel debug labels.
doc-ref: https://github.com/gpsbabel/gpsbabel/blob/e1e195beca8e0f24ca0e41c02d1986af13865cd0/ggv_bin.cc
seq:
  - id: magic
    size: 23
    type: strz
    eos-error: false
    valid:
      any-of:
        - '"DOMGVCRD Ovlfile V2.0:"'
        - '"DOMGVCRD Ovlfile V3.0:"'
        - '"DOMGVCRD Ovlfile V4.0:"'
  - id: body
    type:
      switch-on: magic
      cases:
        '"DOMGVCRD Ovlfile V2.0:"': body_v2
        _: body_v34
types:
  text16:
    seq:
      - id: len_value
        type: u2
      - id: value
        size: len_value
        type: str
  text32:
    seq:
      - id: len_value
        type: u4
      - id: value
        size: len_value
        type: str
  point_v2:
    seq:
      - id: lon
        type: f8
      - id: lat
        type: f8
  point_v34:
    seq:
      - id: lon
        type: f8
      - id: lat
        type: f8
      - id: unknown
        type: f8
  body_v2:
    seq:
      - id: len_map_name
        type: u2
        doc: Usually 0x90 or 0.
      - id: map_name
        size: len_map_name
        type: map_name
      - id: entries
        type: entry_v2
        repeat: eos
  map_name:
    seq:
      - id: unknown
        size: 4
      - id: name
        size-eos: true
        type: strz
        eos-error: false
  entry_v2:
    seq:
      - id: type
        type: u2
        enum: entry_type
      - id: group
        type: u2
      - id: zoom
        type: u2
      - id: subtype
        type: u2
      - id: name
        type: text32
        if: subtype != 1
      - id: body
        type:
          switch-on: type
          cases:
            entry_type::text: text_v2
            entry_type::line: line_v2
            entry_type::area: line_v2
            entry_type::rectangle: geometry_v2
            entry_type::circle: geometry_v2
            entry_type::triangle: geometry_v2
            entry_type::bitmap: bitmap_v2
  text_v2:
    seq:
      - id: color
        type: u2
      - id: size
        type: u2
      - id: trans
        type: u2
      - id: font
        type: u2
      - id: angle
        type: u2
      - id: position
        type: point_v2
      - id: label
        type: text16
  line_v2:
    seq:
      - id: color
        type: u2
      - id: width
        type: u2
      - id: line_type
        type: u2
      - id: num_points
        type: u2
      - id: points
        type: point_v2
        repeat: expr
        repeat-expr: num_points
  geometry_v2:
    seq:
      - id: color
        type: u2
      - id: prop1
        type: u2
      - id: prop2
        type: u2
      - id: angle
        type: u2
      - id: stroke
        type: u2
      - id: area
        type: u2
      - id: position
        type: point_v2
  bitmap_v2:
    seq:
      - id: color
        type: u2
      - id: prop1
        type: u2
      - id: prop2
        type: u2
      - id: prop3
        type: u2
      - id: position
        type: point_v2
      - id: data
        type: text32
  body_v34:
    seq:
      - id: sections
        type: section_v34
        repeat: eos
  section_v34:
    seq:
      - id: header
        type: header_v34
      - id: labels
        type: label_v34
        repeat: expr
        repeat-expr: header.num_labels
      - id: records
        type: record_v34
        repeat: expr
        repeat-expr: header.num_records
      - id: next_magic
        size: 23
        if: not _io.eof
        doc: Magic string preceding the next section (not checked by readers).
  header_v34:
    seq:
      - id: unknown1
        size: 8
      - id: num_labels
        type: u4
      - id: num_records
        type: u4
      - id: label
        type: text16
      - id: unknown2
        type: u2
      - id: unknown3
        type: u2
      - id: unknown4
        type: u2
      - id: len_map_name
        type: u2
      - id: unknown5
        type: u2
      - id: unknown6
        type: u2
      - id: map_name
        size: len_map_name
        type: map_name
  label_v34:
    seq:
      - id: header
        size: 8
      - id: number
        size: 0x14
      - id: text
        type: text16
      - id: flag1
        type: u2
      - id: flag2
        type: u2
  record_v34:
    seq:
      - id: type
        type: u2
        enum: entry_type
      - id: group
        type: u2
      - id: prop2
        type: u2
      - id: prop3
        type: u2
      - id: prop4
        type: u2
      - id: prop5
        type: u2
      - id: prop6
        type: u2
      - id: prop7
        type: u2
      - id: prop8
        type: u2
      - id: zoom
        type: u2
      - id: prop10
        type: u2
      - id: text
        type: text16
        doc: Name of the object (used as track name for lines and areas).
      - id: type1
        type: u2
      - id: object1
        type: text32
        if: type1 != 1
      - id: type2
        type: u2
      - id: object2
        type: text32
        if: type2 != 1
      - id: body
        type:
          switch-on: type
          cases:
            entry_type::text: text_v34
            entry_type::line: line_v34
            entry_type::area: line_v34
            entry_type::line_v34: line_v34
            entry_type::rectangle: geometry_v34
            entry_type::circle: geometry_v34
            entry_type::triangle: geometry_v34
            entry_type::bitmap: bitmap_v34
  text_v34:
    seq:
      - id: prop1
        type: u2
      - id: prop2
        type: u4
      - id: prop3
        type: u2
      - id: prop4
        type: u4
      - id: line_type
        type: u2
      - id: angle
        type: u2
      - id: size
        type: u2
      - id: area
        type: u2
      - id: position
        type: point_v34
      - id: label
        type: text16
  line_v34:
    seq:
      - id: prop1
        type: u2
      - id: prop2
        type: u4
      - id: prop3
        type: u2
      - id: color
        type: u4
      - id: size
        type: u2
      - id: stroke
        type: u2
      - id: num_points
        type: u2
      - id: padding
        type: u2
        if: _parent.type == entry_type::area
      - id: points
        type: point_v34
        repeat: expr
        repeat-expr: num_points
  geometry_v34:
    seq:
      - id: prop1
        type: u2
      - id: prop2
        type: u4
      - id: prop3
        type: u2
      - id: color
        type: u4
      - id: prop5
        type: u4
      - id: prop6
        type: u4
      - id: line_type
        type: u2
      - id: angle
        type: u2
      - id: size
        type: u2
      - id: area
        type: u2
      - id: position
        type: point_v34
  bitmap_v34:
    seq:
      - id: prop1
        type: u2
      - id: prop2
        type: u4
      - id: prop3
        type: u2
      - id: prop4
        type: u4
      - id: prop5
        type: u4
      - id: prop6
        type: u4
      - id: position
        type: point_v34
      - id: len_data
        type: u4
      - id: prop
        type: u2
      - id: data
        size: len_data
enums:
  entry_type:
    0x02: text
    0x03: line
    0x04: area
    0x05: rectangle
    0x06: circle
    0x07: triangle
    0x09: bitmap
    0x17: line_v34
