meta:
  id: metakit
  title: Metakit database file
  application: Metakit
  file-extension: mk
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Metakit is an embedded, column-oriented database library by Equi4
  Software. A datafile holds views (tables) whose properties (columns) are
  each stored as one contiguous area of the file. Metakit databases can
  also be attached to an executable or a script (Tcl "kits").

  The file starts with an 8-byte header: the magic `JL` (data written on a
  little-endian platform) or `LJ` (big-endian), a "valid" byte 0x1A, a
  header type byte, and a 32-bit big-endian pointer to the end of a 16-byte
  footer. The footer gives the offset of the table of contents (TOC), which
  starts with a format marker and the structure definition string, e.g.
  `companies[name:S,offices[department:S,address:S],revenue:D]`, followed by
  the row counts and the position and size of each column.

  Integers in the TOC are "byte-packed": 7 bits per byte, most significant
  first, with bit 7 set only on the last byte; a leading zero byte marks a
  negative (one's complement) value. Strings in the TOC are prefixed with
  their length as such an integer.

  This spec parses the header, the footer and the start of the TOC (format
  marker and structure definition). Interpreting the column positions
  requires parsing the structure definition string, so the rest of the TOC
  and the column data are not covered. The database is expected at the
  start of the file; when it is attached to another file, its footer is
  the last 16 bytes of the file instead.
doc-ref:
  - https://equi4.com/metakit/format.html
  - https://wiki.tcl-lang.org/page/Metakit+file+format
  - https://github.com/jnorthrup/metakit/blob/master/src/persist.cpp
  - https://github.com/ome/ome-metakit/blob/e68d11d07ee4cd515a3143fcb7dbeab09ca09de7/src/main/java/ome/metakit/MetakitReader.java
  - https://github.com/ome/ome-metakit/blob/e68d11d07ee4cd515a3143fcb7dbeab09ca09de7/src/main/java/ome/metakit/MetakitTools.java
seq:
  - id: magic
    size: 2
    type: str
    encoding: ASCII
    valid:
      any-of: ['"JL"', '"LJ"']
    doc: '`JL` if the column data is little-endian, `LJ` if it is big-endian.'
  - id: valid
    contents: [0x1a]
  - id: header_type
    type: u1
    doc: 0 for a valid header.
  - id: ofs_footer_end
    type: u4
    doc: Offset of the end of the 16-byte footer.
instances:
  is_little_endian:
    value: magic == "JL"
  footer:
    pos: ofs_footer_end - 16
    type: footer
  toc:
    pos: footer.ofs_toc
    size: footer.len_toc
    type: toc
types:
  footer:
    doc: |
      Two 8-byte marks: one that gives the end of the data, and one that
      locates the table of contents.
    seq:
      - id: end_mark_tag
        contents: [0x80]
      - id: end_mark_len
        type: b24
        doc: Unused, 0.
      - id: len_database
        type: u4
        doc: Size of the database data before the footer.
      - id: toc_mark_tag
        contents: [0x80]
      - id: len_toc
        type: b24
        doc: Size of the table of contents.
      - id: ofs_toc
        type: u4
        doc: Offset of the table of contents.
  toc:
    seq:
      - id: format_marker
        type: packed_int
      - id: len_structure
        type: packed_int
      - id: structure
        size: len_structure.value
        type: str
        encoding: UTF-8
        doc: |
          Definition of all views: comma-separated `name[properties]`, where each
          property is `name:type` (types S string, I integer, L long, F float,
          D double, B binary, M memo) or a nested subview definition.
  packed_int:
    seq:
      - id: groups
        type: 'packed_int_group(_index == 0 ? 0 : groups[_index - 1].value)'
        repeat: until
        repeat-until: _.is_last
    instances:
      is_negative:
        value: groups[0].raw == 0
      value:
        value: 'is_negative ? ~groups.last.value : groups.last.value'
  packed_int_group:
    params:
      - id: value_before
        type: s8
    seq:
      - id: raw
        type: u1
    instances:
      is_last:
        value: raw & 0x80 != 0
      value:
        value: (value_before << 7) | (raw & 0x7f)
