meta:
  id: aamp_v2
  title: AAMP Binary Resource Parameter Archive
  application:
    - Switch Toolbox
    - aamptool
    - aamp
    - Wild Bits
  file-extension:
    - aamp
    - bxml
    - bas
    - baglblm
    - baglccr
    - baglclwd
    - baglcube
    - bagldof
    - baglenv
    - baglenvset
    - baglfila
    - bagllmap
    - bagllref
    - baglmf
    - baglshpp
    - baiprog
    - baslist
    - bassetting
    - batcl
    - batcllist
    - bawareness
    - bawntable
    - bbonectrl
    - bchemical
    - bchmres
    - bdemo
    - bdgnenv
    - bdmgparam
    - bdrop
    - bgapkginfo
    - bgapkglist
    - bgenv
    - bglght
    - bgmsconf
    - bgparamlist
    - bgsdw
    - bksky
    - blifecondition
    - blod
    - bmodellist
    - bmscdef
    - bmscinfo
    - bnetfp
    - bphyscharcon
    - bphyscontact
    - bphysics
    - bphyslayer
    - bphysmaterial
    - bphyssb
    - bphyssubmat
    - bptclconf
    - brecipe
    - brgbw
    - brgcon
    - brgconfig
    - brgconfiglist
    - bsfbt
    - bsft
    - bshop
    - bumii
    - bvege
    - bactcapt
  xref:
    zeldamods: AAMP
  license: AGPL-3.0-or-later
  endian: le
  bit-endian: le
seq:
  - id: header
    type: header
    doc-ref: https://zeldamods.org/wiki/AAMP#Header
  - id: pio_type
    size: header.pio_offset
    type: strz
    encoding: UTF-8
    doc: Parameter IO type, typically "xml"
  - id: parameter_lists
    type: parameter_list(_index)
    repeat: expr
    repeat-expr: header.num_lists
    doc-ref: https://zeldamods.org/wiki/AAMP#Parameter_list
  - id: parameter_objects
    type: parameter_object(_index)
    repeat: expr
    repeat-expr: header.num_objects
    doc-ref: https://zeldamods.org/wiki/AAMP#Parameter_object
  - id: parameters
    type: parameter(_index)
    repeat: expr
    repeat-expr: header.num_parameters
    doc-ref: https://zeldamods.org/wiki/AAMP#Parameter
  - id: data_section
    size: header.data_section_size
    doc-ref: https://zeldamods.org/wiki/AAMP#Section_order
  - id: string_section
    size: header.string_section_size
    doc-ref: https://zeldamods.org/wiki/AAMP#Section_order
  - id: unknown_uint32_section
    type: u4
    repeat: expr
    repeat-expr: header.num_unknown_uints
    doc: Purpose is unknown. May be unused.
    doc-ref: https://zeldamods.org/wiki/AAMP#Section_order
instances:
  ofs_parameter_lists:
    value: 0x30 + header.pio_offset
  ofs_parameter_objects:
    value: ofs_parameter_lists + 12 * header.num_lists
  ofs_parameters:
    value: ofs_parameter_objects + 8 * header.num_objects
types:
  header:
    seq:
      - id: magic
        contents: AAMP
      - id: version
        type: u4
        doc: Should be "2"
      - id: flags
        type: u4
        doc: |
          TODO
          Flags (LittleEndian 1 << 0, UTF8 1 << 1)
          What does this mean?
        doc-ref: https://zeldamods.org/wiki/AAMP#Header
      - id: file_size
        type: u4
      - id: pio_version
        type: u4
      - id: pio_offset
        type: u4
        doc: |
          Offset of the root parameter list (the parameter IO), relative to
          the end of this header (0x30). The parameter IO type string fills
          the gap.
      - id: num_lists
        type: u4
      - id: num_objects
        type: u4
      - id: num_parameters
        type: u4
      - id: data_section_size
        type: u4
      - id: string_section_size
        type: u4
      - id: num_unknown_uints
        type: u4
        doc: number of uint32s after the string section
  parameter_list:
    params:
      - id: idx
        type: u4
        doc: Index of this list in `_root.parameter_lists`
    seq:
      - id: name_crc32
        type: u4
        doc: |
          CRC32 checksum of the name of this list.
          Can be compared against this list to get the name:
        doc-ref: https://github.com/KillzXGaming/AampLibrary/blob/master/AampLibraryCSharp/aamp_hashed_names.txt
      - id: child_lists_offset
        type: u2
        doc: Offset to child lists, divided by 4 and relative to parameter list start
      - id: num_child_lists
        type: u2
        doc: Number of child lists
      - id: child_objects_offset
        type: u2
        doc: Offset to child objects, divided by 4 and relative to parameter list start
      - id: num_child_objects
        type: u2
        doc: Number of child objects
    instances:
      ofs_start:
        value: _root.ofs_parameter_lists + 12 * idx
      ofs_child_lists:
        value: ofs_start + child_lists_offset * 4
        doc: Absolute offset of the first child list
      idx_first_child_list:
        value: (ofs_child_lists - _root.ofs_parameter_lists) / 12
        doc: |
          Index of the first child list in `_root.parameter_lists`; the
          children are the next `num_child_lists` entries (meaningless when
          there are none)
      ofs_child_objects:
        value: ofs_start + child_objects_offset * 4
        doc: Absolute offset of the first child object
      idx_first_child_object:
        value: (ofs_child_objects - _root.ofs_parameter_objects) / 8
        doc: |
          Index of the first child object in `_root.parameter_objects`; the
          children are the next `num_child_objects` entries (meaningless when
          there are none)
  parameter_object:
    params:
      - id: idx
        type: u4
        doc: Index of this object in `_root.parameter_objects`
    seq:
      - id: name_crc32
        type: u4
        doc: |
          CRC32 checksum of the name of this object.
          Can be compared against this list to get the name:
        doc-ref: https://github.com/KillzXGaming/AampLibrary/blob/master/AampLibraryCSharp/aamp_hashed_names.txt
      - id: child_offset
        type: u2
        doc: Offset to child parameters, divided by 4 and relative to parameter object start
      - id: num_child_params
        type: u2
        doc: Number of child parameters
    instances:
      ofs_start:
        value: _root.ofs_parameter_objects + 8 * idx
      ofs_child_params:
        value: ofs_start + child_offset * 4
        doc: Absolute offset of the first child parameter
      idx_first_child_param:
        value: (ofs_child_params - _root.ofs_parameters) / 8
        doc: |
          Index of the first child parameter in `_root.parameters`; the
          children are the next `num_child_params` entries (meaningless when
          there are none)
  parameter:
    params:
      - id: idx
        type: u4
        doc: Index of this parameter in `_root.parameters`
    seq:
      - id: name_crc32
        type: u4
        doc: |
          CRC32 checksum of the name of this parameter.
          Can be compared against this list to get the name:
        doc-ref: https://github.com/KillzXGaming/AampLibrary/blob/master/AampLibraryCSharp/aamp_hashed_names.txt
      - id: data_offset
        type: b24
        doc: Offset to data, divided by 4 and relative to parameter start.
      - id: parameter_type
        type: b8
        enum: parameter_type
        doc-ref: https://zeldamods.org/wiki/AAMP#ParameterType
    instances:
      ofs_start:
        value: _root.ofs_parameters + 8 * idx
      ofs_data:
        value: ofs_start + data_offset * 4
        doc: |
          Absolute offset of the value (in the data or string section). For
          buffer types, the number of elements is the u4 just before it.
enums:
  parameter_type:
    0:  bool
    1:
      id: f4
      -orig-id: f32
      doc-ref: https://zeldamods.org/wiki/AAMP#ParameterType
    2:  int
    3:  vec2
    4:  vec3
    5:  vec4
    6:  color
    7:  string32
    8:  string64
    9:  curve1
    10: curve2
    11: curve3
    12: curve4
    13: buffer_int
    14: buffer_f32
    15: string256
    16: quat
    17: u32
    18: buffer_u32
    19: buffer_binary
    20: string_ref
    21: none_special
