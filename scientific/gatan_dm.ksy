meta:
  id: gatan_dm
  title: Gatan Digital Micrograph DM3/DM4
  application: Gatan DigitalMicrograph (GMS)
  file-extension:
    - dm3
    - dm4
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Image/spectrum file format of Gatan DigitalMicrograph, widely used in
  electron microscopy. Versions 3 (`.dm3`) and 4 (`.dm4`) share the same
  structure: a small header followed by a tree of tags. Each tag is either
  a tag group (containing further tags) or a data tag holding a typed value
  (simple number, string, struct, or array, which can be an array of
  structs, strings or arrays). The image data itself is stored as array
  tags (`ImageList / ImageData / Data`), described by sibling tags such as
  `DataType` and `Dimensions`.

  Header fields, tag names and type descriptions are big-endian; the
  actual tag data values are in the byte order flagged in the header
  (practically always little-endian). DM4 widens all counts and lengths in
  the type descriptions to 64 bits and adds a 64-bit byte size before the
  contents of every tag.

  This spec parses the complete tag tree and decodes simple values,
  structs and arrays of structs/strings/arrays. Arrays of simple values
  (such as the image data) and strings are exposed as raw bytes. Files
  observed in the wild end with 8 zero bytes after the root tag group,
  which are left unparsed.
doc-ref:
  - https://github.com/hyperspy/rosettasciio/blob/main/rsciio/digitalmicrograph/_api.py
  - https://github.com/ercius/openNCEM/blob/master/ncempy/io/dm.py
seq:
  - id: version
    type: u4
    valid:
      any-of: [3, 4]
  - id: len_file
    type:
      switch-on: version
      cases:
        3: u4
        4: u8
    doc: File size in bytes as recorded in the header.
  - id: byte_order
    type: u4
    enum: byte_order
    doc: Byte order of tag data values.
  - id: root
    type: tag_group(false)
types:
  tag_group:
    params:
      - id: has_len
        type: bool
        doc: Whether a DM4 tag size precedes the group (all groups except the root).
    seq:
      - id: len_group
        type: u8
        if: has_len and _root.version == 4
        doc: Size of the group contents in bytes (DM4 only).
      - id: is_sorted
        type: u1
      - id: is_open
        type: u1
      - id: num_tags
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
      - id: tags
        type: tag
        repeat: expr
        repeat-expr: num_tags
  tag:
    seq:
      - id: kind
        type: u1
        enum: tag_kind
      - id: len_name
        type: u2
      - id: name
        size: len_name
        type: str
        encoding: ISO-8859-1
        doc: Tag name; may be empty, in which case the tag is identified by its position.
      - id: body
        type:
          switch-on: kind
          cases:
            tag_kind::group: tag_group(true)
            tag_kind::data: tag_data
  tag_data:
    seq:
      - id: len_tag
        type: u8
        if: _root.version == 4
        doc: Size of the data tag contents in bytes (DM4 only).
      - id: delimiter
        contents: '%%%%'
      - id: num_type_info
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
        doc: Number of integers in the following type description.
      - id: type_def
        type: type_def
      - id: value
        type: tag_value(type_def)
  type_def:
    doc: |
      Recursive description of a tag value type. An array holds the element
      type followed by the number of elements; a struct holds a list of
      field types.
    seq:
      - id: enc_type_raw
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
      - id: struct_def
        type: struct_def
        if: enc_type == data_type::struct
      - id: len_string
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
        if: enc_type == data_type::string
        doc: Length of the string in bytes.
      - id: elem_type
        type: type_def
        if: enc_type == data_type::array
      - id: num_elems
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
        if: enc_type == data_type::array
    instances:
      enc_type:
        value: enc_type_raw
        enum: data_type
      is_simple:
        value: >-
          enc_type != data_type::struct and enc_type != data_type::string
          and enc_type != data_type::array
      simple_size:
        value: |
          enc_type == data_type::s2 or enc_type == data_type::u2 ? 2 :
          enc_type == data_type::s4 or enc_type == data_type::u4 or enc_type == data_type::f4 ? 4 :
          enc_type == data_type::f8 or enc_type == data_type::s8 or enc_type == data_type::u8 ? 8 :
          1
        if: is_simple
        doc: Size of a value of this simple type in bytes.
  struct_def:
    seq:
      - id: len_struct_name
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
        doc: Length of the struct name (unused, normally 0; no name bytes follow).
      - id: num_fields
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
      - id: fields
        type: struct_field
        repeat: expr
        repeat-expr: num_fields
  struct_field:
    seq:
      - id: len_field_name
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
        doc: Length of the field name (unused, normally 0; no name bytes follow).
      - id: field_type_raw
        type:
          switch-on: _root.version
          cases:
            3: u4
            4: u8
    instances:
      field_type:
        value: field_type_raw
        enum: data_type
        doc: Simple type of the field.
  tag_value:
    doc: A value laid out according to a type description.
    params:
      - id: type_def
        type: type_def
    seq:
      - id: simple
        type: simple_value(type_def.enc_type)
        if: type_def.is_simple
      - id: str_data
        size: type_def.len_string
        if: type_def.enc_type == data_type::string
        doc: Raw string bytes.
      - id: struct_value
        type: struct_value(type_def.struct_def)
        if: type_def.enc_type == data_type::struct
      - id: array_data
        size: type_def.num_elems * type_def.elem_type.simple_size
        if: is_simple_array
        doc: |
          Raw bytes of an array of simple values (e.g. image data), in the
          tag data byte order.
      - id: array_items
        type: tag_value(type_def.elem_type)
        repeat: expr
        repeat-expr: type_def.num_elems
        if: type_def.enc_type == data_type::array and not is_simple_array
        doc: Elements of an array of structs, strings or arrays.
    instances:
      is_simple_array:
        value: type_def.enc_type == data_type::array and type_def.elem_type.is_simple
  struct_value:
    params:
      - id: struct_def
        type: struct_def
    seq:
      - id: fields
        type: simple_value(struct_def.fields[_index].field_type)
        repeat: expr
        repeat-expr: struct_def.num_fields
  simple_value:
    meta:
      endian:
        switch-on: _root.byte_order
        cases:
          byte_order::big: be
          byte_order::little: le
    params:
      - id: enc_type
        type: u8
        enum: data_type
    seq:
      - id: value
        type:
          switch-on: enc_type
          cases:
            data_type::s2: s2
            data_type::s4: s4
            data_type::u2: u2
            data_type::u4: u4
            data_type::f4: f4
            data_type::f8: f8
            data_type::bool: u1
            data_type::char: s1
            data_type::octet: u1
            data_type::s8: s8
            data_type::u8: u8
enums:
  byte_order:
    0: big
    1: little
  tag_kind:
    20: group
    21: data
  data_type:
    2: s2
    3: s4
    4: u2
    5: u4
    6: f4
    7: f8
    8: bool
    9: char
    10: octet
    11: s8
    12: u8
    15: struct
    18: string
    20: array
