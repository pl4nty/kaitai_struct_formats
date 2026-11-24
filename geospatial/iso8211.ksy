meta:
  id: iso8211
  title: ISO/IEC 8211 data descriptive file
  file-extension:
    - '000'
    - ddf
  xref:
    iso: '8211'
    wikidata: Q29644119
  license: CC0-1.0
  ks-version: '0.9'
  encoding: ASCII
doc: |
  ISO/IEC 8211 ("Specification for a data descriptive file for
  information interchange") is a generic, self-describing container
  for exchanging records of structured data. It is the base of IHO S-57
  electronic navigational charts (`.000` cells), the US SDTS, and the
  ADRG / ASRP / USRP raster formats.

  A file is a sequence of records. Each record is a 24-character ASCII
  leader (record length, leader identifier, field area start and the
  widths of the directory entry parts), a directory of
  `(tag, field length, field position)` entries terminated by a field
  terminator (0x1E), and a field area. The first record, the Data
  Descriptive Record (DDR, leader identifier `L`), defines every field
  tag: data structure and type codes, field name, array descriptor
  (subfield labels) and format controls. The following Data Records
  (DR, identifier `D`) carry field instances whose subfields are to be
  decoded with those format controls.

  This spec parses the leaders, directories and DDR field
  definitions; DR field bodies are kept raw because their layout is
  defined by the DDR format controls at run time. Records with a zero
  record length, `R` (header-reusing) data records and `^` padding at
  the end of ASRP/USRP files are not supported.
doc-ref:
  - https://github.com/OSGeo/gdal/blob/6d7a6388745ef760b68d3ea460d700f4be5479c4/frmts/iso8211/ddfmodule.cpp
  - https://github.com/OSGeo/gdal/blob/6d7a6388745ef760b68d3ea460d700f4be5479c4/frmts/iso8211/ddfrecord.cpp
  - https://github.com/OSGeo/gdal/blob/6d7a6388745ef760b68d3ea460d700f4be5479c4/frmts/iso8211/ddffielddefn.cpp
  - https://github.com/OSGeo/gdal/blob/6d7a6388745ef760b68d3ea460d700f4be5479c4/frmts/iso8211/iso8211.h
seq:
  - id: records
    type: record(_index == 0)
    repeat: eos
types:
  record:
    params:
      - id: is_ddr
        type: bool
        doc: True for the first record, the Data Descriptive Record.
    seq:
      - id: leader
        type: leader
      - id: directory
        size: leader.ofs_field_area - 24
        type: directory(leader)
      - id: field_area
        size: leader.len_record - leader.ofs_field_area
        type: 'field_area(directory, is_ddr ? leader.len_field_control.to_i : 0)'
  leader:
    doc: 24-character record leader.
    seq:
      - id: len_record_str
        -orig-id: _recLength
        size: 5
        type: str
      - id: interchange_level
        size: 1
        type: str
        doc: '"1", "2" or "3" in a DDR.'
      - id: leader_identifier
        -orig-id: _leaderIden
        size: 1
        type: str
        doc: |
          "L" for the DDR, "D" for a data record, "R" for a data record whose leader and
          directory are reused.
      - id: inline_code_extension_indicator
        size: 1
        type: str
      - id: version_number
        size: 1
        type: str
      - id: application_indicator
        size: 1
        type: str
      - id: len_field_control
        -orig-id: _fieldControlLength
        size: 2
        type: str
        doc: Number of field control characters at the start of each DDR field definition.
      - id: ofs_field_area_str
        -orig-id: _fieldAreaStart
        size: 5
        type: str
      - id: extended_char_set
        size: 3
        type: str
      - id: len_size_field_length
        -orig-id: _sizeFieldLength
        size: 1
        type: str
      - id: len_size_field_pos
        -orig-id: _sizeFieldPos
        size: 1
        type: str
      - id: reserved
        size: 1
        type: str
      - id: len_size_field_tag
        -orig-id: _sizeFieldTag
        size: 1
        type: str
    instances:
      len_record:
        value: len_record_str.to_i
      ofs_field_area:
        value: ofs_field_area_str.to_i
        doc: Offset of the field area from the start of the record.
      len_entry_length:
        value: len_size_field_length.to_i
      len_entry_pos:
        value: len_size_field_pos.to_i
      len_entry_tag:
        value: len_size_field_tag.to_i
  directory:
    params:
      - id: leader
        type: leader
    seq:
      - id: entries
        type: directory_entry(leader)
        repeat: expr
        repeat-expr: (_io.size - 1) / (leader.len_entry_tag + leader.len_entry_length + leader.len_entry_pos)
      - id: terminator
        contents: [0x1e]
  directory_entry:
    params:
      - id: leader
        type: leader
    seq:
      - id: tag
        size: leader.len_entry_tag
        type: str
      - id: len_field_str
        size: leader.len_entry_length
        type: str
      - id: ofs_field_str
        size: leader.len_entry_pos
        type: str
    instances:
      len_field:
        value: len_field_str.to_i
      ofs_field:
        value: ofs_field_str.to_i
        doc: Offset of the field from the start of the field area.
  field_area:
    params:
      - id: directory
        type: directory
      - id: len_field_control
        type: s4
        doc: Field control length for DDR field definitions, 0 for data records.
    instances:
      fields:
        type: field(directory.entries[_index], len_field_control)
        repeat: expr
        repeat-expr: directory.entries.size
  field:
    params:
      - id: entry
        type: directory_entry
      - id: len_field_control
        type: s4
    instances:
      body:
        pos: entry.ofs_field
        size: entry.len_field - 1
        type:
          switch-on: len_field_control != 0
          cases:
            true: field_definition(len_field_control)
        doc: Field contents without the trailing field terminator (0x1E).
      terminator:
        pos: entry.ofs_field + entry.len_field - 1
        contents: [0x1e]
  field_definition:
    doc: |
      DDR field definition. For the file control field (tag `0000`) the
      array descriptor holds the list of tag pairs describing the field
      tree and there are no format controls.
    params:
      - id: len_field_control
        type: s4
    seq:
      - id: data_struct_code
        size: 1
        type: str
        doc: 0 (or space) elementary, 1 vector, 2 array, 3 concatenated.
      - id: data_type_code
        size: 1
        type: str
        doc: |
          0 (or space) character string, 1 implicit point, 2 explicit
          point, 3 scaled explicit point, 4 character mode bit string,
          5 bit string, 6 mixed data types.
      - id: field_controls_rest
        size: len_field_control - 2
        type: str
        doc: Auxiliary controls, printable graphics and escape sequence.
      - id: name
        type: str
        terminator: 0x1f
        eos-error: false
      - id: array_descriptor
        type: str
        terminator: 0x1f
        eos-error: false
        doc: Subfield labels, e.g. `RCNM!RCID!EXPP`, or `*`-prefixed for repeating groups.
      - id: format_controls
        size-eos: true
        type: str
        doc: Subfield formats, e.g. `(b11,b14,2b11,3A)`.
