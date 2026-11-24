# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/dlf/dlf_file.ksy

meta:
  id: qualcomm_dlf
  title: Qualcomm DLF log file
  license: GPL-3.0-only
  imports:
    - diag_log_f
  endian: le

seq:
  - id: logs
    type: diag_log_f::inner_log
    include: true
    repeat: eos
