meta:
  id: android_binary_manifest
  title: Android binary XML
  file-extension: xml
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  XML files inside an Android application package (APK), most notably
  `AndroidManifest.xml`, are not stored as text but in a compiled binary
  form. It keeps the structure of the document (namespaces, elements,
  attributes and character data) as a sequence of chunks that refer to
  strings in a string pool, which is the first chunk of the file.

  Attribute values can be references to resources, which need the
  `resources.arsc` file of the package to be resolved.
doc-ref: https://github.com/aosp-mirror/platform_frameworks_base/blob/master/libs/androidfw/include/androidfw/ResourceTypes.h
seq:
  - id: magic
    contents: [0x03, 0x00]
    doc: Chunk type of an XML document.
  - id: len_header
    type: u2
  - id: len_file
    type: u4
  - id: chunks
    type: chunk
    repeat: eos
types:
  chunk:
    -orig-id: ResChunk_header
    seq:
      - id: type
        type: u2
        enum: chunk_type
      - id: len_header
        -orig-id: headerSize
        type: u2
        doc: Size of the chunk header in bytes, including these 8 bytes.
      - id: len_chunk
        -orig-id: size
        type: u4
        doc: Size of the chunk in bytes, including its header.
      - id: body
        size: len_chunk - 8
        type:
          switch-on: type
          cases:
            'chunk_type::string_pool': string_pool
            'chunk_type::xml_resource_map': xml_resource_map
            'chunk_type::xml_start_namespace': xml_namespace
            'chunk_type::xml_end_namespace': xml_namespace
            'chunk_type::xml_start_element': xml_start_element
            'chunk_type::xml_end_element': xml_end_element
            'chunk_type::xml_cdata': xml_cdata
  string_pool:
    -orig-id: ResStringPool_header
    seq:
      - id: num_strings
        -orig-id: stringCount
        type: u4
      - id: num_styles
        -orig-id: styleCount
        type: u4
      - id: flags
        type: u4
      - id: ofs_strings
        -orig-id: stringsStart
        type: u4
        doc: Offset of the string data from the start of the chunk.
      - id: ofs_styles
        -orig-id: stylesStart
        type: u4
        doc: Offset of the style data from the start of the chunk.
      - id: strings
        type: string_ref
        repeat: expr
        repeat-expr: num_strings
      - id: style_offsets
        type: u4
        repeat: expr
        repeat-expr: num_styles
    instances:
      is_sorted:
        value: (flags & 0x001) != 0
      is_utf8:
        value: (flags & 0x100) != 0
        doc: Strings are encoded in UTF-8 instead of UTF-16.
  string_ref:
    seq:
      - id: ofs_string
        type: u4
        doc: Offset of the string from the start of the string data.
    instances:
      string:
        pos: _parent.ofs_strings - 8 + ofs_string
        type:
          switch-on: _parent.is_utf8
          cases:
            true: string_utf8
            false: string_utf16
  string_utf16:
    seq:
      - id: num_chars_high
        type: u2
      - id: num_chars_low
        type: u2
        if: (num_chars_high & 0x8000) != 0
      - id: value
        size: num_chars * 2
        type: str
        encoding: UTF-16LE
        doc: Followed by a zero code unit.
    instances:
      num_chars:
        value: >-
          (num_chars_high & 0x8000) != 0
          ? ((num_chars_high & 0x7fff) << 16) | num_chars_low
          : num_chars_high
        doc: |
          Length in UTF-16 code units; stored in 4 bytes with the highest
          bit set if it does not fit into 15 bits.
  string_utf8:
    seq:
      - id: num_chars
        type: length_utf8
        doc: Length in UTF-16 code units.
      - id: len_value
        type: length_utf8
        doc: Length in bytes.
      - id: value
        size: len_value.value
        type: str
        encoding: UTF-8
        doc: Followed by a zero byte.
  length_utf8:
    doc: |
      Length stored in 2 bytes with the highest bit set if it does not fit
      into 7 bits.
    seq:
      - id: high
        type: u1
      - id: low
        type: u1
        if: (high & 0x80) != 0
    instances:
      value:
        value: '(high & 0x80) != 0 ? ((high & 0x7f) << 8) | low : high'
  xml_resource_map:
    doc: |
      Resource IDs of the attribute names: the ID at index N belongs to the
      string N of the string pool.
    seq:
      - id: resource_ids
        type: u4
        repeat: eos
  xml_namespace:
    -orig-id: ResXMLTree_namespaceExt
    seq:
      - id: node
        type: xml_node
      - id: idx_prefix
        -orig-id: prefix
        type: u4
        doc: Index of the namespace prefix in the string pool.
      - id: idx_uri
        -orig-id: uri
        type: u4
        doc: Index of the namespace URI in the string pool.
  xml_start_element:
    -orig-id: ResXMLTree_attrExt
    seq:
      - id: node
        type: xml_node
      - id: idx_namespace
        -orig-id: ns
        type: u4
        doc: |
          Index of the namespace URI of the element in the string pool, or
          0xffff_ffff if it has none.
      - id: idx_name
        -orig-id: name
        type: u4
        doc: Index of the element name in the string pool.
      - id: ofs_attributes
        -orig-id: attributeStart
        type: u2
        doc: Offset of the attributes from `idx_namespace`, normally 20.
      - id: len_attribute
        -orig-id: attributeSize
        type: u2
        doc: Size of one attribute in bytes, normally 20.
      - id: num_attributes
        -orig-id: attributeCount
        type: u2
      - id: id_index
        -orig-id: idIndex
        type: u2
        doc: Number of the "id" attribute, counted from 1, or 0 if none.
      - id: class_index
        -orig-id: classIndex
        type: u2
        doc: Number of the "class" attribute, counted from 1, or 0 if none.
      - id: style_index
        -orig-id: styleIndex
        type: u2
        doc: Number of the "style" attribute, counted from 1, or 0 if none.
      - id: attributes
        size: len_attribute
        type: xml_attribute
        repeat: expr
        repeat-expr: num_attributes
  xml_attribute:
    -orig-id: ResXMLTree_attribute
    seq:
      - id: idx_namespace
        -orig-id: ns
        type: u4
        doc: |
          Index of the namespace URI of the attribute in the string pool,
          or 0xffff_ffff if it has none.
      - id: idx_name
        -orig-id: name
        type: u4
        doc: Index of the attribute name in the string pool.
      - id: idx_raw_value
        -orig-id: rawValue
        type: u4
        doc: |
          Index of the original text of the value in the string pool, or
          0xffff_ffff if it was not kept.
      - id: typed_value
        -orig-id: typedValue
        type: value
  xml_end_element:
    -orig-id: ResXMLTree_endElementExt
    seq:
      - id: node
        type: xml_node
      - id: idx_namespace
        -orig-id: ns
        type: u4
      - id: idx_name
        -orig-id: name
        type: u4
  xml_cdata:
    -orig-id: ResXMLTree_cdataExt
    seq:
      - id: node
        type: xml_node
      - id: idx_data
        -orig-id: data
        type: u4
        doc: Index of the character data in the string pool.
      - id: typed_data
        -orig-id: typedData
        type: value
  xml_node:
    -orig-id: ResXMLTree_node
    seq:
      - id: line_number
        -orig-id: lineNumber
        type: u4
        doc: Line of the original text file the node comes from.
      - id: idx_comment
        -orig-id: comment
        type: u4
        doc: |
          Index of a comment on the node in the string pool, or 0xffff_ffff
          if there is none.
  value:
    -orig-id: Res_value
    seq:
      - id: len_value
        -orig-id: size
        type: u2
        doc: Size of this structure in bytes, 8.
      - id: reserved
        -orig-id: res0
        type: u1
      - id: data_type
        -orig-id: dataType
        type: u1
        enum: data_type
      - id: data
        type: u4
        doc: |
          Depending on `data_type` a number, a resource ID or an index into
          the string pool.
enums:
  chunk_type:
    0x0000: null_type
    0x0001: string_pool
    0x0002: table
    0x0003: xml
    0x0100: xml_start_namespace
    0x0101: xml_end_namespace
    0x0102: xml_start_element
    0x0103: xml_end_element
    0x0104: xml_cdata
    0x0180: xml_resource_map
  data_type:
    0x00: null_type
    0x01: reference
    0x02: attribute
    0x03: string
    0x04: float
    0x05: dimension
    0x06: fraction
    0x07: dynamic_reference
    0x08: dynamic_attribute
    0x10: int_dec
    0x11: int_hex
    0x12: int_boolean
    0x1c: int_color_argb8
    0x1d: int_color_rgb8
    0x1e: int_color_argb4
    0x1f: int_color_rgb4
