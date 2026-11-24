meta:
  id: pci_cap_advanced_features
  title: PCI advanced features capability
  license: 0BSD
  endian: le

doc: |
  Advanced Features (AF) capability for conventional PCI, capability ID
  0x13. Parsed from the byte after the next-capability pointer.

doc-ref: |
  PCI-SIG ENGINEERING CHANGE NOTICE
  Advanced Capabilities for Conventional PCI

seq:
  - id: length
    type: u1
    doc: Length of the capability structure, always 6.
  - id: capabilities
    -orig-id: AF Capabilities
    type: capabilities
  - id: control
    -orig-id: AF Control
    type: control
  - id: status
    -orig-id: AF Status
    type: status

types:
  capabilities:
    seq:
      - id: reserved
        type: b6
      - id: function_level_reset_capable
        -orig-id: FLR_CAP
        type: b1
      - id: transactions_pending_capable
        -orig-id: TP_CAP
        type: b1

  control:
    seq:
      - id: reserved
        type: b7
      - id: initiate_function_level_reset
        -orig-id: Initiate FLR
        type: b1

  status:
    seq:
      - id: reserved
        type: b7
      - id: transactions_pending
        -orig-id: TP
        type: b1
