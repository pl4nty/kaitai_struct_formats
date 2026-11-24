# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/diag/response.ksy
meta:
  id: diag_response
  title: Qualcomm DIAG response
  license: GPL-3.0-only
  imports:
    - diag_cmd_code
    - diag_verno_f_rsp
    - diag_log_config_f_rsp
    - diag_log_f
    - diag_cmd_ext_f
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
        'diag_cmd_code::diag_cmd::verno_f': diag_verno_f_rsp
        'diag_cmd_code::diag_cmd::log_config_f': diag_log_config_f_rsp
        'diag_cmd_code::diag_cmd::log_f': diag_log_f
        'diag_cmd_code::diag_cmd::cmd_ext_f': diag_cmd_ext_f
        _: diag_unknown
