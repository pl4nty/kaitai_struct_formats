# Imported from https://github.com/tuyenvokhac-itr/bioring-monitoring-vv-sdk/blob/b0fd460fabcb25b96ae2d8e8ea02ce4690f5a3ff/psoc6_dfu/schema/psoc6_dfu_response.ksy
meta:
  id: psoc6_dfu_response_packet
  title: PSoC 6 DFU response packet
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: sop
    contents: [0x01]
  - id: status_code
    type: u1
    enum: dfu_status_code
  - id: len_data
    type: u2
  - id: data
    size: len_data
  - id: checksum
    type: u2
  - id: eop
    contents: [0x17]
types:
  enter_response:
    seq:
      - id: silicon_id
        type: u4
      - id: silicon_rev
        type: u1
      - id: dfu_sdk_version
        size: 3
enums:
  dfu_status_code:
    0x00: success
    0x02: error_verify
    0x03: error_length
    0x04: error_data
    0x05: error_cmd
    0x08: error_checksum
    0x0A: error_row
    0x0B: error_row_access
    0x0F: error_unknown
