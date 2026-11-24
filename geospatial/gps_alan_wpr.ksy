meta:
  id: gps_alan_wpr
  title: Alan Map500 waypoints and routes
  application:
    - Alan Map500 (OS 2.xx)
    - Holux GM101
  file-extension: wpr
  license: CC0-1.0
  ks-version: '0.11'
  encoding: ISO-8859-1
  endian: le
doc: |
  Waypoint and route file (default name `TEMPWPRT.WPR`) of the Alan Map500
  handheld GPS receiver running operating system 2.xx (the Holux GM101 is said
  to be identical). The file is a raw memory image of fixed-size tables: a
  waypoint header, 1000 waypoint slots, a route header and 50 route slots,
  padded to 64 KiB.

  The headers' `idx` arrays list the slots in display order (-1 = none), and
  the `used` arrays mark which slots are occupied (0xff) or free (0). Route
  points are given as indices into the waypoint header's `idx` array.

  Coordinates are stored in 1/36000 degree units; the stored `y` is the negated
  latitude. Names and comments are padded with spaces.
doc-ref:
  - https://github.com/GPSBabel/gpsbabel/blob/gpsbabel_1_6_0/alan.cc
  - https://www.gpsbabel.org/htmldoc-development/fmt_alanwpr.html
seq:
  - id: wpthdr
    type: wpthdr
  - id: wpts
    type: wpt
    repeat: expr
    repeat-expr: 1000
  - id: rtehdr
    type: rtehdr
  - id: rtes
    type: rte
    repeat: expr
    repeat-expr: 50
types:
  wpthdr:
    seq:
      - id: id
        contents: [0x00, 0xa6, 0x38, 0x5c]
        doc: '`WPT_HDR_ID`, 0x5C38A600.'
      - id: num
        type: s2
        doc: Number of waypoints in use.
      - id: next
        type: s2
      - id: idx
        type: s2
        repeat: expr
        repeat-expr: 1000
      - id: used
        type: u1
        repeat: expr
        repeat-expr: 1000
  wpt:
    seq:
      - id: name
        size: 8
        type: str
      - id: comment
        size: 12
        type: str
      - id: pt
        type: point
      - id: date
        type: date
      - id: time
        type: s4
        doc: Seconds since midnight (UTC).
      - id: usecount
        type: s2
        doc: Number of routes this waypoint is used in.
      - id: checked
        type: s1
      - id: reserved
        type: s1
  rtehdr:
    seq:
      - id: id
        contents: [0x00, 0x59, 0x7f, 0xd8]
        doc: '`RTE_HDR_ID`, 0xD87F5900.'
      - id: num
        type: s2
        doc: Number of routes in use.
      - id: next
        type: s2
      - id: idx
        type: s2
        repeat: expr
        repeat-expr: 50
      - id: used
        type: u1
        repeat: expr
        repeat-expr: 50
      - id: rteno
        type: s2
        doc: Active route, or -1 for none.
  rte:
    seq:
      - id: name
        size: 8
        type: str
      - id: comment
        size: 12
        type: str
      - id: wptnum
        type: s2
        doc: Number of valid entries in `wptidx`.
      - id: wptidx
        type: s2
        repeat: expr
        repeat-expr: 150
      - id: reserved
        type: s2
      - id: date
        type: date
      - id: time
        type: s4
        doc: Seconds since midnight (UTC).
  point:
    seq:
      - id: x
        type: s4
        doc: Longitude in 1/36000 degree.
      - id: y
        type: s4
        doc: Negated latitude in 1/36000 degree.
    instances:
      longitude:
        value: x / 36000.0
      latitude:
        value: -y / 36000.0
  date:
    seq:
      - id: day
        type: u1
      - id: month
        type: u1
      - id: year
        type: u2
