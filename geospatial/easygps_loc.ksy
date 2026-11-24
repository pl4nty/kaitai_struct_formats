meta:
  id: easygps_loc
  title: EasyGPS binary location file
  application: EasyGPS (TopoGrafix)
  file-extension: loc
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Old binary waypoint ("location") file of TopoGrafix EasyGPS, identified
  by a "TerraByte Location File Copyright <year> TopoGrafix" text line.
  After the header, each waypoint record starts with 'W' and consists of
  tagged fields (name, description, notes, URL, icon, latitude, longitude
  and a few unknown values) terminated by a 0xff tag. Files written by
  GPSBabel end with a single 0x00 byte after the last record.

  The layout is reverse engineered; this spec follows the GPSBabel reader
  and writer. The text encoding is not documented (GPSBabel declares it
  ASCII); Windows-1252 is assumed here. Fields with unknown tags cannot
  be skipped (their length is unknown) and stop parsing.
doc-ref:
  - https://github.com/gpsbabel/gpsbabel/blob/e1e195beca8e0f24ca0e41c02d1986af13865cd0/easygps.cc
  - https://github.com/gpsbabel/gpsbabel/blob/e1e195beca8e0f24ca0e41c02d1986af13865cd0/xmldoc/formats/easygps.xml
seq:
  - id: magic
    contents: TerraByte Location File
  - id: header_text
    type: str
    terminator: 0x0a
    encoding: ASCII
    doc: Rest of the header line, e.g. " Copyright 2001 TopoGrafix".
  - id: unknown1
    type: u1
    doc: Unknown byte (0x0b in files written by GPSBabel, 0x0e seen in EasyGPS files).
  - id: records
    type: record
    repeat: until
    repeat-until: not _.is_waypoint or _io.eof
types:
  record:
    seq:
      - id: marker
        type: u1
        doc: "'W' (0x57) for a waypoint; anything else (normally 0x00) ends the file."
      - id: fields
        type: field
        repeat: until
        repeat-until: _.tag == field_tag::end
        if: is_waypoint
    instances:
      is_waypoint:
        value: marker == 0x57
  field:
    seq:
      - id: tag
        type: u1
        enum: field_tag
      - id: body
        type:
          switch-on: tag
          cases:
            field_tag::short_name: pascal_string
            field_tag::description: pascal_string
            field_tag::description_alt: pascal_string
            field_tag::notes: pascal_string
            field_tag::url_link_text: pascal_string
            field_tag::icon: pascal_string
            field_tag::notes_cstr: c_string
            field_tag::url_cstr: c_string
            field_tag::url_link_text_cstr: c_string
            field_tag::latitude: coordinate
            field_tag::longitude: coordinate
            field_tag::unknown_65: unknown8
            field_tag::unknown_66: unknown8
            field_tag::unknown_84: unknown4
            field_tag::unknown_85: unknown4
            field_tag::unknown_86: unknown4
  pascal_string:
    seq:
      - id: len_value
        type: u1
      - id: value
        size: len_value
        type: str
        encoding: windows-1252
  c_string:
    seq:
      - id: value
        type: strz
        encoding: windows-1252
  coordinate:
    seq:
      - id: value
        type: f8
        doc: Latitude or longitude in decimal degrees.
  unknown4:
    seq:
      - id: value
        size: 4
  unknown8:
    seq:
      - id: value
        size: 8
enums:
  field_tag:
    0x01: short_name
    0x02: description_alt
    0x03: description
    0x05: notes
    0x06: url_link_text
    0x07: icon
    0x08: notes_cstr
    0x09: url_cstr
    0x10: url_link_text_cstr
    0x63: latitude
    0x64: longitude
    0x65: unknown_65
    0x66: unknown_66
    0x84: unknown_84
    0x85: unknown_85
    0x86:
      id: unknown_86
      doc: Possibly a time or proximity value.
    0xff: end
