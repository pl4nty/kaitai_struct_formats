meta:
  id: gps_delorme_saroute
  title: DeLorme Street Atlas route
  application:
    - DeLorme Street Atlas
    - DeLorme Topo USA
    - GPSBabel
  file-extension:
    - anr
    - rte
    - rtd
  tags:
    - geospatial
  license: CC0-1.0
  ks-version: '0.11'
  encoding: UTF-8
  endian: le
doc: |
  Route files of DeLorme Street Atlas and Topo USA (`.anr`, `.rte`,
  `.rtd`). The format is only partially understood; this spec follows
  the reverse-engineered reader of GPSBabel and keeps unknown parts as
  raw bytes.

  A file has a short header, a route name record, a list of control
  point records (start, stops, vias, end) and a list of route segments,
  each made of routing records with a turn description and a polyline.

  Coordinates are stored as `0x80000000 - degrees * 0x800000`; the
  longitude is additionally negated (`longitude` instances give
  east-positive degrees). Control point records store latitude and
  longitude in swapped order.
doc-ref: https://github.com/gpsbabel/gpsbabel/blob/0cb3c0e44804a03be9d5373968a897c5c107e7e8/saroute.cc
seq:
  - id: magic
    type: u2
  - id: version
    type: u2
  - id: unknown1
    type: u4
  - id: unknown2
    type: u4
    if: version >= 6
  - id: unknown3
    type: u4
    if: version >= 6
  - id: name_record
    type: record_header
  - id: name_record_body
    size: name_record.len_body
    type: name_record_body
  - id: name_record_tail
    size: name_record_body.len_name - 4
    doc: |
      GPSBabel skips `len_name - 4` bytes after the name record; the
      purpose of these bytes is unknown.
  - id: num_control_points
    type: u4
  - id: control_points
    type: control_point
    repeat: expr
    repeat-expr: num_control_points
  - id: num_segments
    type: u4
    doc: Number of route segments (start + end + stops + vias - 1).
  - id: segments
    type: segment
    repeat: expr
    repeat-expr: num_segments
  - id: unknown_trailer
    size-eos: true
    doc: Remaining data, not read by GPSBabel.
types:
  record_header:
    seq:
      - id: unknown
        type: u2
      - id: len_body
        type: u4
  name_record_body:
    seq:
      - id: unknown1
        size: 0x1a
      - id: len_name
        type: u2
      - id: name
        size: len_name
        type: str
        doc: Route name.
      - id: unknown2
        size-eos: true
  control_point:
    seq:
      - id: header
        type: record_header
      - id: body
        size: header.len_body
        type: control_point_body
      - id: unknown_trailer
        size: 8
        if: _root.version >= 6
  control_point_body:
    doc: |
      The coordinates are followed by address and comment strings among
      unknown data; their offset changed with Topo USA 6.0 (format
      version 11).
    seq:
      - id: longitude_raw
        type: u4
        doc: Unlike in routing points, the longitude comes first here.
      - id: latitude_raw
        type: u4
    instances:
      latitude:
        value: (0x8000_0000 - latitude_raw.as<s8>) / 8388608.0
      longitude:
        value: -(0x8000_0000 - longitude_raw.as<s8>) / 8388608.0
  segment:
    seq:
      - id: params_header
        type: record_header
      - id: params
        size: params_header.len_body
        doc: Unknown record (route parameters?).
      - id: num_routing_records
        type: u4
      - id: routing_records
        type: routing_record
        repeat: expr
        repeat-expr: num_routing_records
  routing_record:
    seq:
      - id: header
        type: record_header
      - id: body
        size: header.len_body
        type: routing_record_body
      - id: unknown_trailer
        size: 8
        if: _root.version > 10
  routing_record_body:
    seq:
      - id: len_turn_text
        type: u2
      - id: turn_text
        size: len_turn_text
        type: strz
        doc: Turn instruction; empty for points without a turn.
      - id: unknown1
        size: 8
      - id: segment_length
        type: f8
        doc: Length of this leg in kilometers.
      - id: transit_time
        type: u4
        doc: Travel time of this leg in seconds.
      - id: unknown2
        size: 0x1c
      - id: start_time
        type: u4
        doc: Start time of this leg in seconds, relative to the route start.
      - id: unknown3
        size: 8
      - id: num_points
        type: u2
      - id: points
        type: point
        repeat: expr
        repeat-expr: num_points
  point:
    seq:
      - id: latitude_raw
        type: u4
      - id: longitude_raw
        type: u4
    instances:
      latitude:
        value: (0x8000_0000 - latitude_raw.as<s8>) / 8388608.0
      longitude:
        value: -(0x8000_0000 - longitude_raw.as<s8>) / 8388608.0
