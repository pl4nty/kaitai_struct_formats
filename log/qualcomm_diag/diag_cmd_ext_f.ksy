# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/diag/command/diag_cmd_ext_f.ksy
# Licence and copyright: see _community/README.md
meta:
  id: diag_cmd_ext_f
  title: Qualcomm DIAG extended command (DIAG_CMD_EXT_F)
  license: GPL-3.0-only
  imports:
    - diag_response
  # alias diag_multi_radio_cmd_f
  endian: le

seq:
  - id: version
    type: u1
    valid:
      min: 1
  - id: header
    type:
      switch-on: version
      cases:
        1: v1_header
        2: v2_header
  - id: payload
    type: diag_response

types:
  v1_header:
    seq:
      - id: proc_id
        type: u2
        enum: proc_type
      - id: subscription_id # in case of Dual SIM
        type: u4

  v2_header:
    seq:
      - id: proc_id
        type: u2
        enum: proc_type
      - id: len_name
        type: u1
      - id: time_offset_type
        type: u1
        enum: time_offset_type
      - id: time_offset
        type: u8
      - id: ulog_name
        size: 24
        type: strz
        encoding: ASCII

enums:
  time_offset_type:
    0: no_custom_offset
    1: sync_offset_type
    255: no_offset
  proc_type:
    0: modem
    1: app
    2: common_dual
    3: qdsp6
    4: riva
    5: slpi
    6: wdsp
    7: cdsp
    255: no_proc
