# Imported from https://github.com/schiebel/casatabstream/blob/5cb9e9ed69ed770dde95b4cefe04bd4e01291344/ksy/table_metadata.ksy
# Licence and copyright: see _community/README.md

meta:
  id: casa_table_metadata
  title: Casacore Table Data System header layout
  application:
    - casacore
    - AIPS++
    - CASA
  file-extension: dat
  tags:
    - astronomy
    - scientific
  license: LGPL-2.0-or-later
  endian: be

# Copyright (C) 2022
# Associated Universities, Inc. Washington DC, USA.
#
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.
#
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public
# License for more details.
#
# You should have received a copy of the GNU Library General Public License
# along with this library; if not, write to the Free Software Foundation,
# Inc., 675 Massachusetts Ave, Cambridge, MA 02139, USA.
#


###
### casacore data types:
### --------------------------------------------------------------------------------------
###   0           TpBool
###   1           TpChar
###   2           TpUChar
###   3           TpShort
###   4           TpUShort
###   5           TpInt
###   6           TpUInt
###   7           TpFloat
###   8           TpDouble
###   9           TpComplex
###   10          TpDComplex
###   11          TpString
###   12          TpTable
###   13          TpArrayBool
###   14          TpArrayChar
###   15          TpArrayUChar
###   16          TpArrayShort
###   17          TpArrayUShort
###   18          TpArrayInt
###   19          TpArrayUInt
###   20          TpArrayFloat
###   21          TpArrayDouble
###   22          TpArrayComplex
###   23          TpArrayDComplex
###   24          TpArrayString
###   25          TpRecord
###   26          TpOther
###   27          TpQuantity
###   28          TpArrayQuantity
###   29          TpInt64
###   30          TpArrayInt64
###

doc: |
  The [casacore table system](https://casacore.github.io/casacore-notes/255.html)
  is a binary, table
  oriented storage system for radio astronoy data. Many systems use it to store,
  manipulate and process
  the data collected from radio telescopes. It can be used to store both the raw
  visibilities as collected
  from the telescopes and the images that are produced as a final product. This
  file parses only the
  table description stored in the table.dat file within the table directory.

seq:
  - id: magic
    contents: [ 0xbe, 0xbe, 0xbe, 0xbe ]
    doc: casa magic unsigned int 3200171710  190 190 190 190
  - id: size
    type: u4
  - id: type
    type: string
  - id: version
    type: u4
  - id: nrows
    type:
      switch-on: version
      cases:
        1: u4
        2: u4
        3: u8
  - id: little_endian
    type: u4
  - id: name
    type: string
    doc: expect "PlainTable"
  - id: desc
    type: table_desc
    doc:                                         TableDesc
      
types:
  complex8:
    seq:
      - id: r
        type: f4
      - id: i
        type: f4
  complex16:
    seq:
      - id: r
        type: f8
      - id: i
        type: f8
  string:
    seq:
      - id: len
        type: u4
      - id: value
        size: len
        type: str
        encoding: ASCII

  array:
    params:
      - id: type
        type: u2
    seq:
      - id: size
        type: u4
      - id: cxx_type
        type: string
      - id: version
        type: u4
      - id: num_shape
        type: u4
      - id: shape
        type: u4
        repeat: expr
        repeat-expr: num_shape
      - id: num_elements
        type: u4
      - id: elements
        type:
          switch-on: type
          cases:
            13: u1
            14: s1
            15: u1
            16: s2
            17: u2
            18: s4
            19: u4
            20: f4
            21: f8
            22: complex8
            23: complex16
            24: string
            30: s8
        repeat: expr
        repeat-expr: num_elements

  default:
    params:
      - id: type
        type: u2
    seq:
      - id: value
        type:
          switch-on: type
          cases:
            0:  u1
            1:  s1
            2:  u1
            3:  s2
            4:  u2
            5:  s4
            6:  u4
            7:  f4
            8:  f8
            9:  complex8
            10: complex16
            11: string
            29: s8
            _: array(type)
                  
  data_value:
    params:
      - id: type
        type: u2
    seq:
      - id: value
        type:
          switch-on: type
          cases:
            0:  u1
            1:  s1
            2:  u1
            3:  s2
            4:  u2
            5:  s4
            6:  u4
            7:  f4
            8:  f8
            9:  complex8
            10: complex16
            11: string
            12: string
            25: table_record
            29: s8
            _: array(type)

  type_name:
    params:
      - id: value
        type: str
    seq:
      - id: size
        type: u4
      - id: name
        size: value.length # `str.length` gives the number of *characters*, not bytes as we would need here; but in ASCII they're equal
        type: str
        encoding: ASCII
        valid:
          eq: value
  record_field_desc:
    seq:
      - id: name
        type: string
      - id: type
        type: s4
      - id: subtable_filler
        type: u4
        if: type == 12
      - id: string_array_filler_size
        type: u4
        if: type == 24
      - id: string_array_filler_iposition   # for some reason this is always IPosition( 1, -1 ), single dim containing -1
        type: iposition
        if: type == 24
      - id: comment
        type: string
        if: type != 25
      - id: subrecord
        type: subrecord_desc
        if: type == 25
  record_field_value:
    params:
      - id: type
        type: s4
    seq:
      - id: value
        type: data_value(type)

  hacky:
    seq:
      - id: size
        type: u4
      - id: type
        type: string

  subrecord_desc:
    seq:
      - id: size
        type: u4
      - id: type
        type: type_name("RecordDesc")
      - id: version
        type: u4
      - id: num_fields
        type: s4
      - id: comment
        type: string

  record_desc:
    seq:
      - id: size
        type: u4
      - id: type
        type: type_name("RecordDesc")
      - id: version
        type: u4
      - id: num_fields
        type: s4
      - id: fields
        type: record_field_desc
        repeat: expr
        repeat-expr: num_fields
      - id: record_type
        type: s4
      - id: values
        type: record_field_value(fields[_index].type)
        repeat: expr
        repeat-expr: num_fields

  iposition:
    seq:
      - id: type
        type: string
      - id: version
        type: u4
        doc: 1 implies 4 byte shape numbers but 2 implies 8 byte shape numbers
      - id: num_elements
        type: u4
      - id: elements
        type:
          switch-on: version
          cases:
            1: u4
            2: u8
        repeat: expr
        repeat-expr: num_elements

  table_record:
    seq:
      - id: size
        type: u4
      - id: type
        type: type_name("TableRecord")
      - id: version
        type: u4
      - id: desc
        type: record_desc
  column_details:
    seq:
      - id: version
        type: u4
      - id: cxx_type
        type: string
      - id: version_parent
        type: u4
      - id: name
        type: string
      - id: comment
        type: string
      - id: manager_type
        type: string
      - id: manager_group
        type: string
      - id: data_type
        type: s4
      - id: options
        type: s4
      - id: dimensions
        type: s4
        doc: MAY HAVE SHAPE NEXT to be done
      - id: max_length
        type: s4
      - id: shape
        type: iposition
        if: dimensions != 0
      - id: filler_xxx
        type: u4
        if: dimensions != 0
      - id: keywords
        type: table_record
      - id: column_template_class_version
        type: u4
        doc: e.g. ScalarColumnDesc<T> putDesc, ScaColDesc.tcc line 149
      - id: default
        type: default(data_type)
        if: dimensions == 0 and data_type != 25
      - id: filler
        type: u1
        if: dimensions != 0 and data_type != 25

  table_desc:
    seq:
      - id: size
        type: u4
      - id: type
        type: string
      - id: version
        type: u4
      - id: name
        type: string
      - id: table
        type:
          ###
          ### there seems to be no enum that can be used to distinguish
          ### reference tables from regular tables
          ###
          switch-on: type.value
          cases:
            '"TableDesc"': regular_table_desc
            '"RefTable"': reference_table_desc(version)

  ###
  ### column mapping found in reference table
  ###
  column_map:
    seq:
      - id: key
        type: string
      - id: val
        type: string

  ###
  ### details for tables with 32bit row specs
  ###
  column_row_details_32b:
    seq:
      - id: num_maps_base
        type: u4
      - id: has_row_order
        type: u1
      - id: num_maps
        type: u4
      - id: maps
        type: u4
        repeat: expr
        repeat-expr: num_maps

  ###
  ### details for tables with 64bit row specs
  ###
  column_row_details_64b:
    seq:
      - id: num_maps_base
        type: u8
      - id: has_row_order
        type: u1
      - id: num_maps
        type: u8
      - id: maps
        type: u4
        repeat: expr
        repeat-expr: num_maps

  ###
  ### reference table description
  ###
  reference_table_desc:
    params:
      - id: version
        type: u4
    seq:
      - id: column_map_size
        type: u4
      - id: column_map_type
        type: type_name("SimpleOrderedMap")
      - id: column_map_version
        type: u4
      - id: default_value
        type: u4
      - id: num_column_maps
        type: u4
      - id: block_allocation_increment
        type: u4
      - id: column_maps
        type: column_map
        repeat: expr
        repeat-expr: num_column_maps
      - id: column_order_size
        type: u4
      - id: column_order_type
        type: type_name("Array")
      - id: column_order_version
        type: u4
      - id: num_column_order_shape
        type: u4
      - id: column_order_shape
        type: u4
        repeat: expr
        repeat-expr: num_column_order_shape
      - id: num_column_order
        type: u4
      - id: column_order
        type: string
        repeat: expr
        repeat-expr: num_column_order
      - id: row_order
        type:
          switch-on: version
          cases:
            2: column_row_details_32b
            1: column_row_details_64b
    instances:
      type:
        value: 2

  ###
  ### standard table description
  ###
  regular_table_desc:
    seq:
      - id: desc_version
        type: string
      - id: comment
        type: string
      - id: user_keywords
        type: table_record
      - id: private_keywords
        type: table_record
      - id: columns
        type: column_spec
    instances:
      type:
        value: 1

  columnset_options_type:
    seq:
      - id: value
        type: s4
      - id: block_size
        type: u4

  columnset_manager:
    seq:
      - id: cxx_type
        type: string
      - id: sequence_number
        type: u4
  storage_desc:
    seq:
      - id: version
        type: s4
        doc: |
          version was not output for version == 1, so there may be problems for very old
          tables
      - id: nrows
        type:
          switch-on: version
          cases:
            -1: u4
            -2: u4
            -3: u8
      - id: options
        type: columnset_options_type
        if: version == -3
      - id: sequence_number
        type: u4
        doc: unique sequence number... maybe relates to data managers
      - id: num_managers
        type: u4
      - id: managers
        type: columnset_manager
        repeat: expr
        repeat-expr: num_managers

  array_column_storage_details:
    seq:
      - id: shape_column_def
        type: u1
      - id: filler
        type: u4
        if: shape_column_def > 0
      - id: shape
        type: iposition
        if: shape_column_def > 0
            
  storage_details:
    params:
      - id: dimensionality
        type: u4
    seq:
      - id: version
        type: u4
      - id: column_name
        type: string
      - id: column_version
        type: u4
        doc: casacore::ScalarColumnData<unsigned char>::putFileDerived
      - id: manager_number
        type: u4
        doc: casacore::ScalarColumnData<unsigned char>::putFileDerived
      - id: array_details
        type: array_column_storage_details
        if: dimensionality > 0
      - id: random_space
        type: u1
        if: dimensionality < 0
        doc: encountered with refim_point_withline.ms/SOURCE/table.dat

  column_spec:
    seq:
      - id: num_cols
        type: u4
      - id: details
        type: column_details
        repeat: expr
        repeat-expr: num_cols
      - id: storage
        type: storage_desc
      - id: storage_details
        type: storage_details(details[_index].dimensions)
        repeat: expr
        repeat-expr: num_cols
      - id: num_memio
        type: u4
      - id: memio
        type: u1
        repeat: expr
        repeat-expr: num_memio
