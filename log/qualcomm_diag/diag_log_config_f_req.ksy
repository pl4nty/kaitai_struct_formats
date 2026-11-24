# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/diag/command/diag_log_config_f_req.ksy
# Licence and copyright: see _community/README.md
meta:
  id: diag_log_config_f_req
  title: Qualcomm DIAG log config request (DIAG_LOG_CONFIG_F)
  license: GPL-3.0-only
  imports:
    - diag_logging
  endian: le
  bit-endian: le

seq:
  - id: padding
    size: 3
    pad-right: 0x00
  - id: operation
    type: u4
    enum: operation
  - id: action
    size-eos: true
    type:
      switch-on: operation
      cases:
        'operation::disable_op': disable
        'operation::retrieve_id_ranges_op': retrieve_id_ranges
        'operation::retrieve_valid_mask_op': retrieve_valid_mask
        'operation::set_mask_op': set_mask
        'operation::get_mask_op': get_mask

enums:
  operation:
    0: disable_op
    1: retrieve_id_ranges_op
    2: retrieve_valid_mask_op # Note: Not supported by DIAG_EXT_LOG_CONFIG
    3: set_mask_op
    4: get_mask_op

types:
  # Operations:
  disable:
    seq: []
  retrieve_id_ranges:
    seq: []
  retrieve_valid_mask:
    seq:
      - id: equipment_id
        type: u4
        enum: diag_logging::equipment_id
  set_mask:
    seq:
      - id: log_mask
        type: log_mask
  get_mask:
    seq:
      - id: equipment_id
        type: u4
        enum: diag_logging::equipment_id

  # Structures:
  log_mask:
    seq:
      - id: equipment_id
        type: u4
        enum: diag_logging::equipment_id
      - id: num_logs_on_bitfield
        type: u4
      - id: logs_on_bitfield
        type: b1
        repeat: expr
        repeat-expr: num_logs_on_bitfield
