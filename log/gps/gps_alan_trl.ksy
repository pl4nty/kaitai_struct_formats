meta:
  id: gps_alan_trl
  title: Alan Map500 tracklog
  application:
    - Alan Map500 (OS 2.xx)
    - Holux GM101
  file-extension: trl
  license: CC0-1.0
  ks-version: '0.11'
  encoding: ISO-8859-1
  endian: le
doc: |
  Tracklog file (default name `TEMP_TRK.TRL`) of the Alan Map500 handheld GPS
  receiver running operating system 2.xx (the Holux GM101 is said to be
  identical). The file is a raw image of 8 fixed-size tracklog slots, followed
  by the tracklog header at offset 0x40000.

  Each 64 KiB block holds two tracklogs. A tracklog has room for 2500 points;
  the coordinate array comes first, followed by the speed/height array. Only
  the first `trkhdr.totalpt` points of a slot whose `occupied` flag is set are
  meaningful.

  Coordinates are stored in 1/36000 degree units; the stored `y` is the negated
  latitude.
doc-ref:
  - https://github.com/GPSBabel/gpsbabel/blob/gpsbabel_1_6_0/alan.cc
  - https://www.gpsbabel.org/htmldoc-development/fmt_alantrl.html
seq:
  - id: blocks
    size: 0x10000
    type: trklog_block
    repeat: expr
    repeat-expr: 4
  - id: loghdr
    type: loghdr
types:
  trklog_block:
    seq:
      - id: trklogs
        type: trklog
        repeat: expr
        repeat-expr: 2
  trklog:
    seq:
      - id: pt
        type: point
        repeat: expr
        repeat-expr: 2500
      - id: sh
        type: speed_height
        repeat: expr
        repeat-expr: 2500
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
  speed_height:
    seq:
      - id: speed
        type: s2
        doc: Speed in km/h * 200; negative values mean "unknown".
      - id: height
        type: s2
        doc: Altitude in m * 5.
    instances:
      speed_mps:
        value: speed / 720.0
        doc: Speed in m/s.
      height_m:
        value: height / 5.0
        doc: Altitude in metres.
  loghdr:
    seq:
      - id: magic
        -orig-id: id
        contents: [0x00, 0x12, 0xcb, 0x38]
        doc: '`TRL_HDR_ID`, 0x38CB1200.'
      - id: num
        type: s2
      - id: next
        type: s2
      - id: date
        type: date
      - id: time
        type: s4
        doc: Seconds since midnight.
      - id: trkhdr
        type: trkhdr
        repeat: expr
        repeat-expr: 8
  trkhdr:
    seq:
      - id: totalpt
        type: s2
        doc: Number of points in the corresponding tracklog.
      - id: next
        type: s2
      - id: name
        size: 12
        type: strz
      - id: comment
        size: 13
        type: strz
      - id: reserved
        size: 3
      - id: occupied
        type: u4
        doc: 1 if this tracklog slot is used, 0 if not.
      - id: show
        type: u4
        doc: 1 - show, 0 - hide.
      - id: fill
        type: u4
        doc: 1 - stop recording when full, 0 - wrap around.
  date:
    seq:
      - id: day
        type: u1
      - id: month
        type: u1
      - id: year
        type: u2
