# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/diag/request.ksy
meta:
  id: diag_request
  title: Qualcomm DIAG request
  license: GPL-3.0-only
  imports:
    - diag_cmd_code
    - diag_verno_f_req
    - diag_log_config_f_req
    - diag_unknown
  endian: le

seq:
  - id: cmd_code
    type: u1
    enum: diag_cmd_code::diag_cmd
  - id: payload
    size-eos: true
    type:
      switch-on: cmd_code
      cases:
        'diag_cmd_code::diag_cmd::verno_f': diag_verno_f_req
        'diag_cmd_code::diag_cmd::log_config_f': diag_log_config_f_req
        _: diag_unknown
