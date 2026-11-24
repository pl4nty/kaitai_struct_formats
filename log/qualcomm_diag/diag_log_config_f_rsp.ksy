# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/diag/command/diag_log_config_f_rsp.ksy
meta:
  id: diag_log_config_f_rsp
  title: Qualcomm DIAG log config response (DIAG_LOG_CONFIG_F)
  license: GPL-3.0-only
  imports:
    - diag_log_config_f_req
    - diag_logging
  endian: le

seq:
  - id: padding
    size: 3
    pad-right: 0x00
  - id: operation
    type: u4
    enum: diag_log_config_f_req::operation
  - id: status
    type: u4
    enum: status
  - id: action
    size-eos: true
    type:
      switch-on: operation
      cases:
        'diag_log_config_f_req::operation::disable_op': disable
        'diag_log_config_f_req::operation::retrieve_id_ranges_op': retrieve_id_ranges
        'diag_log_config_f_req::operation::retrieve_valid_mask_op': retrieve_valid_mask
        'diag_log_config_f_req::operation::set_mask_op': set_mask
        'diag_log_config_f_req::operation::get_mask_op': get_mask

enums:
  status:
    0: success

types:
  # Operations:
  disable:
    seq: []
  retrieve_id_ranges:
    seq:
      - id: last_item
        type: u4
        repeat: expr
        repeat-expr: 16
  retrieve_valid_mask:
    seq:
      - id: log_mask
        type: diag_log_config_f_req::log_mask
  set_mask:
    seq:
      - id: log_mask
        type: diag_log_config_f_req::log_mask
  get_mask:
    seq:
      - id: log_mask
        type: diag_log_config_f_req::log_mask
