# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/mkw_wpf.ksy
meta:
  id: wiimms_wpf
  title: Wiimms Patch File (WPF/XPF)
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  A header followed by a stream of variable-length patch/condition records
  terminated by a record with selector 0.
seq:
  - id: magic
    type: u4
    valid:
      any-of: [0x57504601, 0x58504601]
    doc: 0x57504601 = "WPF\x01", 0x58504601 = "XPF\x01".
  - id: version
    type: u4
  - id: size
    type: u4
  - id: records
    type: wpf_record
    repeat: eos
types:
  wpf_record:
    seq:
      - id: selector
        type: u1
        doc: 0 ends the list; bits 0x01-0x08 staticr regions, 0x10-0x80 main.dol regions.
      - id: patch_type
        type: u1
        if: selector != 0
        doc: 0 end, 'P' patch, 'E' equal-condition, 'N' not-equal-condition.
      - id: clear_cond
        type: u1
        if: selector != 0
        doc: 0 nothing, 'C' clear previous condition, 'E' invert condition.
      - id: addr_type
        type: u1
        if: selector != 0
        doc: 0 end, 'A' address, 'O' file offset.
      - id: addr
        type: u4
        if: selector != 0
      - id: data_size
        type: u4
        if: selector != 0
      - id: data
        size: (data_size + 3) & ~3
        if: selector != 0
