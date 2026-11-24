# Imported from https://github.com/frazew/rrdmerge/blob/dfb2c0ed1125ef5bd74800c948ab344efa351a4f/rrd32.ksy
meta:
  id: rrd32
  title: RRD (Round-Robin Database) file
  file-extension: rrd
  license: CC0-1.0
  endian: le
seq:
  - id: header
    type: header
  - id: ds_store
    type: ds_def
    repeat: expr
    repeat-expr: header.ds_count
  - id: rra_store
    type: rra_def
    repeat: expr
    repeat-expr: header.rra_count
  - id: live_head
    type: live_head
  - id: pdp_prep_store
    type: pdp_prep
    repeat: expr
    repeat-expr: header.ds_count
  - id: cdp_prep_store
    type:
      switch-on: rra_store[_index].cf
      cases:
        '"MHWPREDICT"': unknown_cdp_prep
        '"HWPREDICT"': unknown_cdp_prep
        '"SEASONAL"': unknown_cdp_prep
        '"DEVSEASONAL"': unknown_cdp_prep
        '"FAILURES"': unknown_cdp_prep
        '"DEVPREDICT"': unknown_cdp_prep
        _: cdp_prep
    repeat: expr
    repeat-expr: header.rra_count
  - id: rra_ptr_store
    type: u4
    repeat: expr
    repeat-expr: header.rra_count
  - id: rra_data_store
    type: rra_data(rra_store[_index].row_count)
    repeat: expr
    repeat-expr: header.rra_count
types:
  header:
    seq:
      - id: magic
        contents: ['RRD', 0]
      - id: version
        size: 4
        type: str
        encoding: ASCII
      - id: padding
        size: 8
      - id: floatcookie
        type: f8
      - id: ds_count
        type: u4
      - id: rra_count
        type: u4
      - id: pdp_step
        type: u4
      - size: 4
        doc: padding
      - id: params
        size: 8
        repeat: expr
        repeat-expr: 10
        doc: unused
  ds_def:
    seq:
      - id: name
        size: 20
        type: str
        terminator: 0
        encoding: ASCII
      - id: datasource
        size: 20
        type: str
        terminator: 0
        encoding: ASCII
      - id: params
        type: ds_params
  ds_params:
    seq:
      - id: min_heartbeat_count
        type: u4
      - id: min_val
        type: f8
      - id: max_val
        type: f8
      - id: cdef
        type: u4
        doc: pointer to encoded rpn expression only applies to DST_CDEF, not supported here
      - id: unused
        size: 8
        repeat: expr
        repeat-expr: 10 - 3
  rra_def:
    seq:
      - id: cf
        size: 20
        type: str
        terminator: 0
        encoding: ASCII
      - id: row_count
        type: u4
      - id: pdp_count
        type: u4
      - size: 4
        doc: padding
      - id: params
        type:
          switch-on: cf
          cases:
            '"MHWPREDICT"': unknown_params
            '"HWPREDICT"': unknown_params
            '"SEASONAL"': unknown_params
            '"DEVSEASONAL"': unknown_params
            '"FAILURES"': unknown_params
            '"DEVPREDICT"': unknown_params
            _: rra_params
  rra_params:
    seq:
      - id: xff
        type: f8
      - id: unused
        size: 8
        repeat: expr
        repeat-expr: 10 - 1
  unknown_params:
    seq:
      - id: params
        size: 8
        repeat: expr
        repeat-expr: 10
  live_head:
    seq:
      - id: last_update
        type: u4
      - id: last_update_usec
        type: u4
  pdp_prep:
    seq:
      - id: last_ds_reading
        size: 32
        type: str
        terminator: 0
        encoding: ASCII
      - id: params
        type: pdp_prep_params
  pdp_prep_params:
    seq:
      - id: unknown_sec_count
        type: u4
      - size: 4
        doc: padding
      - id: current_value
        type: f8
      - id: unused
        size: 8
        repeat: expr
        repeat-expr: 10 - 2
  cdp_prep:
    seq:
      - id: params
        type: cdp_prep_params
        repeat: expr
        repeat-expr: _root.header.ds_count
  cdp_prep_params:
    seq:
      - id: value
        type: f8
      - id: unknown_pdp_count
        type: u4
      - id: unused
        size: 8
        repeat: expr
        repeat-expr: 10 - 4
      - size: 4
        doc: padding
      - id: primary_value
        type: f8
      - id: secondary_value
        type: f8
  unknown_cdp_prep:
    seq:
      - id: unused
        size: 8
        repeat: expr
        repeat-expr: 10
  rra_data:
    params:
      - id: row_count
        type: u4
    seq:
      - id: row
        type: rra_data_row
        repeat: expr
        repeat-expr: row_count
  rra_data_row:
    seq:
      - id: values
        type: f8
        repeat: expr
        repeat-expr: _root.header.ds_count
