# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/smash_xmb.ksy
meta:
  id: smash_xmb
  title: Smash XMB material/LOD metadata (Super Smash Bros. 4/Ultimate)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Smash XMB material/LOD metadata.

  This is a 44-byte header followed by separately located node, property,
  mapped-node, and string tables. Offsets in the header are absolute file
  offsets. Name offsets inside nodes and properties are relative to the
  names string table; property values and mapped-node IDs are relative to
  the values string table. The property table is indexed, not nested inside
  node records: a node owns property_count consecutive entries beginning at
  first_property_index. The node map is an ID-to-node lookup, not the tree.

  The tree is recovered from parent_index. -1 marks a parentless node. It
  scans nodes in table order to find each parent's children rather than
  relying on child_count. Invalid parent indices become orphaned nodes.
  Negative property count and first-property index are clamped to zero by
  that decoder; out-of-range property spans are truncated. The decoder emits
  node names as XML element names and properties as XML attributes, escapes
  attribute values, substitutes "node" for empty or unreadable node names,
  and sanitizes XML tag names. These are conversion rules, not bytes stored
  in the XMB.

  The separate string-offsets table and distinct-property count are not used
  in its XML decoder; their detailed semantics remain unconfirmed.
seq:
  - id: magic
    contents: "XMB "
  - id: num_nodes
    type: u4
    doc: Number of 16-byte node records; the XML decoder requires at least one.
  - id: num_values
    type: u4
    doc: Informational -- sum of per-node property counts.
  - id: num_properties
    type: u4
    doc: Informational -- distinct property name string count.
  - id: num_mapped_nodes
    type: u4
    doc: Number of eight-byte ID-to-node lookup entries.
  - id: string_offsets_table_offset
    type: u4
    doc: |
      Absolute start of a separate string-offset index; its count and element
      semantics are unconfirmed.
  - id: node_table_offset
    type: u4
    doc: Absolute start of num_nodes consecutive 16-byte records.
  - id: property_table_offset
    type: u4
    doc: Absolute start of num_values consecutive eight-byte records.
  - id: node_map_offset
    type: u4
    doc: Absolute start of num_mapped_nodes eight-byte lookup records.
  - id: names_table_offset
    type: u4
    doc: Absolute base for node and property name offsets.
  - id: values_table_offset
    type: u4
    doc: Absolute base for property value and mapped-node ID offsets.
instances:
  nodes:
    pos: node_table_offset
    type: node_t
    repeat: expr
    repeat-expr: num_nodes
  properties:
    pos: property_table_offset
    type: property_t
    repeat: expr
    repeat-expr: num_values
  node_map:
    pos: node_map_offset
    type: node_map_entry_t
    repeat: expr
    repeat-expr: num_mapped_nodes
types:
  node_t:
    seq:
      - id: name_offset
        type: u4
        doc: Offset relative to names_table_offset.
      - id: property_count
        type: s2
        doc: |
          Number of consecutive properties beginning at first_property_index; negative
          values are treated as zero by the XML decoder.
      - id: child_count
        type: s2
        doc: |
          Declared number of children; XML conversion instead discovers children by
          matching parent_index.
      - id: first_property_index
        type: s2
        doc: |
          Index into the global property table, not a byte offset; negative values are
          treated as zero by the XML decoder.
      - id: unk1
        type: s2
        doc: Unknown signed field.
      - id: parent_index
        type: s2
        doc: |
          Parent's zero-based node index; -1 denotes a parentless node. Invalid indices
          are orphaned in XML conversion.
      - id: unk2
        type: s2
        doc: Unknown signed field.
    instances:
      name:
        io: _root._io
        pos: _root.names_table_offset + name_offset
        type: cstr
  property_t:
    seq:
      - id: name_offset
        type: u4
        doc: Offset relative to names_table_offset for this XML attribute name.
      - id: value_offset
        type: u4
        doc: Offset relative to values_table_offset for this XML attribute value.
    instances:
      name:
        io: _root._io
        pos: _root.names_table_offset + name_offset
        type: cstr
      value:
        io: _root._io
        pos: _root.values_table_offset + value_offset
        type: cstr
  node_map_entry_t:
    seq:
      - id: value_offset
        type: u4
        doc: Offset relative to values_table_offset for the lookup ID string.
      - id: node_index
        type: u4
        doc: Zero-based index into the node table associated with this ID.
    instances:
      id:
        io: _root._io
        pos: _root.values_table_offset + value_offset
        type: cstr
  cstr:
    seq:
      - id: value
        type: str
        terminator: 0
        encoding: UTF-8
