meta:
  id: gps_geogrid_viewer_tracklog
  title: Geogrid-Viewer binary tracklog
  application: Geogrid-Viewer
  file-extension: log
  license: CC0-1.0
  ks-version: '0.9'
  encoding: ASCII
  endian: le
doc: |
  Binary GPS track log written by the Geogrid-Viewer map software (a
  popular German topographic map viewer). The file is a NUL-terminated
  ASCII signature `DOMGVGPS Logfile V<version>:` followed by
  fixed-size track point records.

  Version 1.0 records (42 bytes) hold latitude and longitude as degrees,
  minutes and float seconds, course, altitude, speed and the UTC date
  and time. In version 2.5 records (111 bytes) only the coordinates,
  course, altitude and number of satellites are known; the remaining
  bytes (which contain further, undocumented doubles) are kept raw.

  Coordinates are decoded by GPSBabel as
  `degrees + minutes / 60 + seconds / 3600`; its writer stores the
  absolute value of the minutes and seconds next to signed degrees, so
  southern/western values are not round-tripped by that reference.
  An incomplete trailing record is ignored by GPSBabel but rejected by
  this spec.
doc-ref: https://github.com/gpsbabel/gpsbabel/blob/e1e195beca8e0f24ca0e41c02d1986af13865cd0/ggv_log.cc
seq:
  - id: magic
    contents: DOMGVGPS Logfile V
  - id: version
    type: str
    terminator: 0x3a
    valid:
      any-of: ['"1.0"', '"2.5"']
    doc: Format version, followed by `:` in the signature.
  - id: signature_rest
    type: strz
    doc: Rest of the NUL-terminated signature, normally empty.
  - id: points
    size: 'version == "1.0" ? 42 : 111'
    type:
      switch-on: version
      cases:
        '"1.0"': point_v1_0
        '"2.5"': point_v2_5
    repeat: eos
types:
  angle:
    seq:
      - id: degrees
        type: s2
      - id: minutes
        type: u2
      - id: seconds
        type: f4
    instances:
      value:
        value: degrees + minutes / 60.0 + seconds / 3600.0
        doc: Angle in decimal degrees, as computed by GPSBabel.
  point_v1_0:
    seq:
      - id: latitude
        type: angle
      - id: longitude
        type: angle
      - id: course
        type: s2
        doc: Degrees.
      - id: altitude
        type: s2
        doc: Metres; 0 means unknown.
      - id: speed
        type: s2
      - id: reserved
        type: u2
      - id: year
        type: u2
        doc: Full year (e.g. 2002); 0 if the point has no time stamp.
      - id: month
        type: u2
        doc: 1-12.
      - id: day
        type: u2
      - id: hour
        type: u2
      - id: minute
        type: u2
      - id: second
        type: f8
        doc: Seconds including the fractional part.
  point_v2_5:
    seq:
      - id: latitude
        type: angle
      - id: longitude
        type: angle
      - id: course
        type: s2
        doc: Degrees.
      - id: unknown1
        size: 2
      - id: altitude
        type: s2
        doc: Metres; 0 means unknown.
      - id: unknown2
        size: 8
      - id: num_satellites
        type: u1
      - id: unknown3
        size-eos: true
        doc: |
          Undocumented; GPSBabel notes probable doubles at record offsets
          22, 43, 51, 61, 79, 87, 95 and 103.
