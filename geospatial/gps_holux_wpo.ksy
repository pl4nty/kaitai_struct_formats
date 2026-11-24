meta:
  id: gps_holux_wpo
  title: Holux GM-100 waypoint file
  application:
    - Holux GM-100
    - Holux MapShow
    - GPSBabel
  file-extension: wpo
  tags:
    - geospatial
  license: CC0-1.0
  ks-version: '0.11'
  encoding: ASCII
  endian: le
doc: |
  Waypoint/route memory image of the Holux GM-100 GPS receiver
  (25600 bytes; files written by MapShow 1.4 are 25512 bytes long).

  The file has fixed-size tables: a waypoint header with an index of
  used slots, 500 waypoint slots starting at offset 0x5e4, and at
  offset 23600 a route header followed by 20 route slots.

  Coordinates are in 1/36000 degree units (i.e. 1/10 arc second); the
  latitude is stored negated.

  Only the waypoint part is read by GPSBabel. The route slots are
  placed directly after the route header padded to 72 bytes, which is
  consistent with the 25512-byte MapShow file size, but this was not
  verified on a file containing routes.
doc-ref:
  - https://github.com/gpsbabel/gpsbabel/blob/0cb3c0e44804a03be9d5373968a897c5c107e7e8/holux.h
  - https://github.com/gpsbabel/gpsbabel/blob/0cb3c0e44804a03be9d5373968a897c5c107e7e8/holux.cc
seq:
  - id: waypoint_header
    type: waypoint_header
  - id: waypoints
    type: waypoint
    repeat: expr
    repeat-expr: 500
    doc: Waypoint slots; the used ones are listed in `waypoint_header.indexes`.
instances:
  route_header:
    pos: 23600
    type: route_header
  routes:
    pos: 23600 + 72
    type: route
    repeat: expr
    repeat-expr: 20
types:
  waypoint_header:
    -orig-id: WPTHDR
    seq:
      - id: magic
        -orig-id: id
        contents: [0x31, 0xa6, 0x38, 0x5c]
      - id: num_waypoints
        -orig-id: num
        type: s2
      - id: next
        type: s2
        doc: Next waypoint number.
      - id: indexes
        -orig-id: idx
        type: s2
        repeat: expr
        repeat-expr: 500
        doc: |
          Slot index of each waypoint (the first `num_waypoints` are
          valid); -1 if unused.
      - id: used
        type: u1
        repeat: expr
        repeat-expr: 500
        doc: 0xff if the slot is used, 0 otherwise.
  waypoint:
    -orig-id: WPT
    seq:
      - id: name
        size: 8
        type: str
        doc: Space padded.
      - id: comment
        size: 12
        type: str
        doc: Space padded.
      - id: longitude_raw
        -orig-id: iLongitude
        type: s4
      - id: latitude_raw_negated
        -orig-id: iLatitude
        type: s4
      - id: voice_index
        -orig-id: vocidx
        type: s2
        doc: Not used; -1.
      - id: use_count
        -orig-id: usecount
        type: s2
        doc: Number of routes using this waypoint.
      - id: date
        type: date
        doc: All zero if the waypoint has no time.
      - id: time
        type: u4
        doc: Seconds since midnight.
      - id: checked
        type: u1
        doc: Active flag.
      - id: padding
        -orig-id: dummy
        size: 3
    instances:
      longitude:
        value: longitude_raw / 36000.0
        doc: Degrees, east positive.
      latitude:
        value: -latitude_raw_negated / 36000.0
        doc: Degrees, north positive.
  date:
    -orig-id: HX_DATE
    seq:
      - id: day
        type: u1
      - id: month
        type: u1
      - id: year
        type: s2
  route_header:
    -orig-id: RTEHDR
    seq:
      - id: magic
        -orig-id: id
        contents: [0xf0, 0x59, 0x7f, 0xd8]
      - id: num_routes
        -orig-id: num
        type: s2
      - id: next
        type: s2
        doc: Next route number.
      - id: indexes
        -orig-id: idx
        type: s2
        repeat: expr
        repeat-expr: 20
        doc: Slot index of each route; -1 if unused.
      - id: used
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: 0xff if the slot is used, 0 otherwise.
      - id: navigation_route
        -orig-id: rteno
        type: s2
        doc: Number of the route currently navigated, or -1.
  route:
    -orig-id: RTE
    seq:
      - id: name
        size: 8
        type: str
      - id: comment
        size: 12
        type: str
      - id: num_waypoints
        -orig-id: wptnum
        type: s2
      - id: waypoint_indexes
        -orig-id: wptidx
        type: s2
        repeat: expr
        repeat-expr: 30
      - id: reserved
        type: s2
      - id: date
        type: s4
      - id: time
        type: s4
