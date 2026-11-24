# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/diag/command/diag_verno_f_rsp.ksy
# Licence and copyright: see _community/README.md
meta:
  id: diag_verno_f_rsp
  title: Qualcomm DIAG version response (DIAG_VERNO_F)
  license: GPL-3.0-only
  endian: le

seq:
  - id: compile_date # %b %d %Y
    size: 11
    type: str
    terminator: 0x00
    pad-right: 0x20
    encoding: ASCII
  - id: compile_time # %H:%M:%S
    size: 8
    type: str
    terminator: 0x00
    pad-right: 0x20
    encoding: ASCII
  - id: release_date # %b %d %Y
    size: 11
    type: str
    terminator: 0x00
    pad-right: 0x20
    encoding: ASCII
  - id: release_time # %H:%M:%S
    size: 8
    type: str
    terminator: 0x00
    pad-right: 0x20
    encoding: ASCII
  - id: version_directory
    size: 8
    type: str
    terminator: 0x00
    pad-right: 0x20
    encoding: ASCII
  - id: station_class_mark
    type: u1
  - id: mobile_cai_revision
    type: u1
  - id: mobile_model
    type: u1
  - id: mobile_firmware_revision
    type: u1
  - id: slot_cycle_index
    type: u2
  - id: hardware_major_version
    type: u1
  - id: hardware_minor_version
    type: u1
