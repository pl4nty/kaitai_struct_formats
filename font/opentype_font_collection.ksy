# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/font/opentype_font_collection/otff.ksy
# Licence and copyright: see _community/README.md
meta:
  id: opentype_font_collection
  title: Open Type Font File Collection
  file-extension: ttc
  license: MIT
  endian: be
doc: |
  An open type font file collection contains data, in table format, that comprises
  multiple outline fonts.

  Test files can be found in google-noto-sans-cjk-ttc-fonts (name of Fedora
  package)
doc-ref:
  - https://docs.microsoft.com/en-us/typography/opentype/spec/otff#collections
seq:
  - id: magic
    contents: 'ttcf'
  - id: version
    type: version
  - id: num_fonts
    type: u4
    valid:
      min: 1
  - id: ofs_tables
    type: u4
    repeat: expr
    repeat-expr: num_fonts
  - id: dsig_tag
    type: u4
    if: version.major > 1
  - id: dsig_length
    type: u4
    if: version.major > 1
  - id: ofs_dsig
    type: u4
    if: version.major > 1
instances:
  fonts:
    type: font(_index)
    repeat: expr
    repeat-expr: num_fonts
types:
  version:
    seq:
      - id: major
        type: u2
        valid:
          any-of: [1, 2]
      - id: minor
        type: u2
        valid: 0
  font:
    params:
      - id: index
        type: u4
    instances:
      offset_table:
        pos: _root.ofs_tables[index]
        type: offset_table
  offset_table:
    seq:
      - id: magic
        contents: 'OTTO'
      - id: num_tables
        type: u2
      - id: search_range
        type: u2
      - id: entry_selector
        type: u2
      - id: range_shift
        type: u2
      - id: directory_table
        type: dir_table_entry
        repeat: expr
        repeat-expr: num_tables
  dir_table_entry:
    seq:
      - id: tag
        size: 4
        type: str
        encoding: ASCII
      - id: checksum
        type: u4
      - id: offset
        type: u4
      - id: length
        type: u4
    instances:
      raw_value:
        io: _root._io
        pos: offset
        size: length
