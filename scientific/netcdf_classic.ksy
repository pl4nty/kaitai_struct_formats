meta:
  id: netcdf_classic
  title: NetCDF classic / 64-bit offset format
  application: netCDF
  file-extension:
    - nc
    - cdf
  xref:
    mime: application/x-netcdf
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Network Common Data Form (netCDF) classic format (version 1, "CDF\x01")
  and its 64-bit offset variant (version 2, "CDF\x02"), as written by the
  Unidata netCDF library (netCDF-3). A file consists of a header listing
  dimensions, global attributes and variables (with their attributes,
  types, shapes and data offsets), followed by the data of all
  non-record variables and then the interleaved records of all record
  variables (variables whose first dimension is the unlimited "record"
  dimension, i.e. a dimension with length 0).

  This spec parses the whole header, including attribute values. The data
  of each non-record variable is available as raw bytes via the `data`
  instance of the variable; record variable data is interleaved and must
  be assembled by the application using `begin`, `len_data` and the record
  size (sum of `len_data` of all record variables).

  The netCDF-4 format is an HDF5 file and is not covered; neither is the
  CDF-5 (version 5, "64-bit data") variant introduced by PnetCDF.
doc-ref: https://github.com/Unidata/netcdf-c/blob/main/docs/file_format_specifications.md
seq:
  - id: magic
    contents: CDF
  - id: version
    type: u1
    enum: format_version
    valid:
      any-of:
        - format_version::classic
        - format_version::offset_64bit
  - id: num_records
    type: u4
    doc: |
      Length of the record (unlimited) dimension, or 0xffffffff for an
      indeterminate number of records (streaming).
  - id: dim_list
    type: dim_list
  - id: global_attrs
    type: attr_list
  - id: var_list
    type: var_list
instances:
  is_streaming:
    value: num_records == 0xffffffff
types:
  name:
    seq:
      - id: len_value
        type: u4
      - id: value
        size: len_value
        type: str
        encoding: UTF-8
      - id: padding
        size: (4 - len_value % 4) % 4
  dim_list:
    seq:
      - id: tag
        type: u4
        valid:
          any-of: [0, 0x0a]
        doc: NC_DIMENSION (0x0a), or 0 if the list is absent.
      - id: num_dims
        type: u4
      - id: dims
        type: dim
        repeat: expr
        repeat-expr: num_dims
  dim:
    seq:
      - id: name
        type: name
      - id: len_dim
        type: u4
        doc: Length of the dimension; 0 for the record (unlimited) dimension.
    instances:
      is_record_dim:
        value: len_dim == 0
  attr_list:
    seq:
      - id: tag
        type: u4
        valid:
          any-of: [0, 0x0c]
        doc: NC_ATTRIBUTE (0x0c), or 0 if the list is absent.
      - id: num_attrs
        type: u4
      - id: attrs
        type: attr
        repeat: expr
        repeat-expr: num_attrs
  attr:
    seq:
      - id: name
        type: name
      - id: nc_type
        type: u4
        enum: nc_type
      - id: num_values
        type: u4
      - id: values
        size: num_values * ext_size
        type:
          switch-on: nc_type
          cases:
            nc_type::byte: values_s1(num_values)
            nc_type::char: values_char
            nc_type::short: values_s2(num_values)
            nc_type::int: values_s4(num_values)
            nc_type::float: values_f4(num_values)
            nc_type::double: values_f8(num_values)
      - id: padding
        size: (4 - (num_values * ext_size) % 4) % 4
    instances:
      ext_size:
        value: |
          nc_type == nc_type::byte or nc_type == nc_type::char ? 1 :
          nc_type == nc_type::short ? 2 :
          nc_type == nc_type::double ? 8 : 4
        doc: External size of a single value in bytes.
  values_s1:
    params:
      - id: num_values
        type: u4
    seq:
      - id: values
        type: s1
        repeat: expr
        repeat-expr: num_values
  values_char:
    seq:
      - id: value
        size-eos: true
        type: str
        encoding: UTF-8
        doc: |
          Text value. The format does not define the encoding of character
          data; UTF-8 (a superset of ASCII) is assumed here.
  values_s2:
    params:
      - id: num_values
        type: u4
    seq:
      - id: values
        type: s2
        repeat: expr
        repeat-expr: num_values
  values_s4:
    params:
      - id: num_values
        type: u4
    seq:
      - id: values
        type: s4
        repeat: expr
        repeat-expr: num_values
  values_f4:
    params:
      - id: num_values
        type: u4
    seq:
      - id: values
        type: f4
        repeat: expr
        repeat-expr: num_values
  values_f8:
    params:
      - id: num_values
        type: u4
    seq:
      - id: values
        type: f8
        repeat: expr
        repeat-expr: num_values
  var_list:
    seq:
      - id: tag
        type: u4
        valid:
          any-of: [0, 0x0b]
        doc: NC_VARIABLE (0x0b), or 0 if the list is absent.
      - id: num_vars
        type: u4
      - id: vars
        type: var
        repeat: expr
        repeat-expr: num_vars
  var:
    seq:
      - id: name
        type: name
      - id: num_dim_ids
        type: u4
        doc: Rank, i.e. number of dimensions (0 for a scalar).
      - id: dim_ids
        type: u4
        repeat: expr
        repeat-expr: num_dim_ids
        doc: Indices into the root dimension list, outermost first.
      - id: attrs
        type: attr_list
      - id: nc_type
        type: u4
        enum: nc_type
      - id: len_data
        type: u4
        doc: |
          `vsize`: space allocated for the variable's data in bytes (padded to a
          multiple of 4); for a record variable, the space per record.
          0xffffffff is used for variables too large to fit.
      - id: begin
        type:
          switch-on: _root.version
          cases:
            format_version::classic: u4
            format_version::offset_64bit: u8
        doc: Absolute file offset of the variable's (first record's) data.
    instances:
      is_record_var:
        value: num_dim_ids > 0 and _root.dim_list.dims[dim_ids[0]].len_dim == 0
        doc: True if the first dimension is the record dimension.
      data:
        io: _root._io
        pos: begin
        size: len_data
        if: not is_record_var and len_data != 0xffffffff
        doc: |
          Raw data of a non-record variable: values of `nc_type` in
          big-endian, row-major order, padded to 4 bytes.
enums:
  format_version:
    1: classic
    2: offset_64bit
  nc_type:
    1: byte
    2: char
    3: short
    4: int
    5: float
    6: double
