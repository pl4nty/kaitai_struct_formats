meta:
  id: pci_cap_msi_x
  title: PCI MSI-X capability
  license: 0BSD
  endian: le

doc: |
  MSI-X capability, capability ID 0x11. Parsed from the byte after the
  next-capability pointer.

doc-ref: |
  PCI LOCAL BUS SPECIFICATION, REV. 3.0
  p238, 6.8.2. MSI-X Capability and Table Structures

# TODO: check PCIe spec

seq:
  - id: message_control
    type: message_control
  - id: table
    -orig-id: Table Offset/Table BIR
    type: offset_and_bar_indicator
  - id: pending_bit_array
    -orig-id: PBA Offset/PBA BIR
    type: offset_and_bar_indicator

types:
  message_control:
    seq:
      # bits 7:0
      - id: table_size_lower
        type: u1
      # bits 15:8
      - id: msi_x_enable
        type: b1
      - id: function_mask
        type: b1
      - id: reserved
        type: b3
      - id: table_size_upper
        type: b3
    instances:
      table_size:
        value: table_size_lower | (table_size_upper << 8)
        doc: Number of table entries minus 1.

  offset_and_bar_indicator:
    seq:
      - id: raw
        type: u4
    instances:
      offset:
        value: raw & 0xfffffff8
        doc: QWORD aligned offset into the BAR selected by `bar_indicator`.
      bar_indicator:
        -orig-id: BIR
        value: raw & 0x7
      # TODO: plug bar type here
      bar_offset:
        value: bar_indicator * 0x4 + 0x10
        if: bar_indicator < 6
        doc: Config space offset of the selected BAR. Values 6 and 7 are reserved.
