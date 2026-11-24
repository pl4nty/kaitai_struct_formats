# Imported from https://github.com/OpenVolumeMesh/OpenVolumeMesh/blob/1ab7cf290bc38ea303e8d0403683e8cc940f67bc/extra/ovmb-kaitai/ovmb.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ovmb
  title: OVMB (OpenVolumeMesh binary file format)
  file-extension: ovmb
  license: CC0-1.0
  encoding: ASCII
  endian: le
doc:
  OVMB files describe volumetric meshes and associated properties.
doc-ref: http://openvolumemesh.org
seq:

  - id: file_header
    type: file_header
  - id: chunks
    type: chunk
    repeat: eos

enums:
  int_encoding:
    0: none
    1: u8
    2: u16
    4: u32
  vertex_encoding:
    0: none
    1: float
    2: double
  property_entity:
    0: vertex
    1: edge
    2: face
    3: cell
    4: halfedge
    5: halfface
    6: mesh
  topo_type:
    0: polyhedral
    1: tetrahedral
    2: hexahedral
  topo_entity:
    1: edge
    2: face
    3: cell
types:
  file_header:
    seq:
      - id: magic
        contents: ['O', 'V', 'M', 'B', 0xa, 0xd, 0xa, 0xff]
      - id: file_version
        type: u1
      - id: header_version
        type: u1
      - id: vertex_dim
        type: u1
      - id: topo_type
        type: u1
        enum: topo_type
      - id: reserved
        contents: [0, 0, 0, 0]
      - id: n_vertices
        type: u8
      - id: n_edges
        type: u8
      - id: n_faces
        type: u8
      - id: n_cells
        type: u8
  chunk:
    seq:
      - id: type
        size: 4
        type: str
      - id: version
        type: u1
      - id: padding_bytes
        type: u1
      - id: compression
        type: u1
      - id: flags
        type: u1
      - id: file_length
        type: u8
      - id: body
        size: file_length - padding_bytes
        type:
          switch-on: type
          cases:
            '"VERT"': vert_chunk
            '"PROP"': prop_chunk
            '"TOPO"': topo_chunk
            '"DIRP"': propdir_chunk
      - id: padding
        size: padding_bytes
  array_span:
    seq:
      - id: base
        type: u8
      - id: count
        type: u4

  vert_chunk:
    seq:
      - id: span
        type: array_span
      - id: vertex_encoding
        type: u1
        enum: vertex_encoding
      - id: reserved
        contents: [0, 0, 0]
      - id: coordinates
        type:
          switch-on: vertex_encoding
          cases:
            'vertex_encoding::float': f4
            'vertex_encoding::double': f8
        repeat: expr
        repeat-expr: span.count * _root.file_header.vertex_dim

  topo_chunk:
    seq:
      - id: span
        type: array_span

      - id: entity
        type: u1
        enum: topo_entity

      - id: valence
        type: u1
        doc: 0 for variable valence

      - id: valence_encoding
        type: u1
        enum: int_encoding

      - id: handle_encoding
        type: u1
        enum: int_encoding

      - id: handle_offset
        type: u8

      - id: data
        type:
          switch-on: valence
          cases:
            0: topo_data_variable
            _: topo_data_fixed

  topo_data_fixed:
    seq:
      - id: handles
        type:
          switch-on: _parent.handle_encoding
          cases:
            'int_encoding::u8': u1
            'int_encoding::u16': u2
            'int_encoding::u32': u4
        repeat: expr
        repeat-expr: _parent.span.count * _parent.valence


  topo_data_variable:
    seq:
      - id: valences
        type:
          switch-on: _parent.valence_encoding
          cases:
            'int_encoding::u8': u1
            'int_encoding::u16': u2
            'int_encoding::u32': u4
        repeat: expr
        repeat-expr: _parent.span.count
      - id: handles
        type:
          switch-on: _parent.handle_encoding
          cases:
            'int_encoding::u8': u1
            'int_encoding::u16': u2
            'int_encoding::u32': u4

  propdir_chunk:
    seq:
      - id: entry
        type: propdir_entry
        repeat: eos

  string4:
    seq:
      - id: len
        type: u4
      - id: str
        size: len
        type: str
        encoding: UTF-8

  bytes4:
    seq:
      - id: len
        type: u4
      - id: data
        size: len

  propdir_entry:
    seq:
      - id: entity
        type: u1
        enum: property_entity
      - id: name
        type: string4
      - id: data_type_name
        type: string4
      - id: serialized_default
        type: bytes4

  prop_chunk:
    seq:
      - id: span
        type: array_span
      - id: prop_idx
        type: u4
      - id: data
        size-eos: true
