# Imported from https://github.com/darkmentorllc/DarkFirmware_real_i/blob/e6c816c47c2abf5d4e885694a9095b2fc0d9a6d9/06_RTL_Config_KaitaiStruct/rtl_config.ksy
meta:
  id: realtek_bt_config
  title: Realtek Config
  license: LicenseRef-All-Rights-Reserved
  ks-version: 0.9
  endian: le
  bit-endian: le
doc: Config format used by Realtek to write values to memory/flash
seq:
  - id: header
    type: main_header
  - id: entries
    type: rtl_tlv
    repeat: eos
types:
  main_header:
    seq:
      - id: magic
        size: 4
        contents: [0x55, 0xab, 0x23, 0x87]
      - id: total_size
        type: u2
  rtl_tlv:
    seq:
      - id: offset
        type: u2
        doc: offset in flash?
      - id: len_value
        type: u1
      - id: value
        size: len_value
