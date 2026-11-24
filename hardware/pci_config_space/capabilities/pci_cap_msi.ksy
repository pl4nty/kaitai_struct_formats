meta:
  id: pci_cap_msi
  title: PCI MSI capability
  license: 0BSD
  endian: le

doc: |
  Message Signaled Interrupts (MSI) capability, capability ID 0x05. Parsed
  from the byte after the next-capability pointer.

doc-ref: |
  PCI LOCAL BUS SPECIFICATION, REV. 3.0
  p232, 6.8.1. MSI Capability Structure

# TODO: check PCIe spec

seq:
  - id: message_control
    type: message_control
  - id: message_address
    type: message_address
  - id: message_data
    type: u2
  # Per-vector masking
  - id: reserved
    type: u2
    if: message_control.per_vector_masking_capable
  - id: mask_bits
    type: u4
    if: message_control.per_vector_masking_capable
  - id: pending_bits
    type: u4
    if: message_control.per_vector_masking_capable

types:
  message_control:
    seq:
      # bits 7:0
      - id: address_64bit_capable
        type: b1
      - id: multiple_message_enable
        type: b3
        doc: log2 of the number of vectors allocated.
      - id: multiple_message_capable
        type: b3
        doc: log2 of the number of vectors requested.
      - id: msi_enable
        type: b1
      # bits 15:8
      - id: reserved
        type: b7
      - id: per_vector_masking_capable
        type: b1

  message_address:
    # DWORD aligned address for the MSI memory write transaction
    # Lower two bits are reserved and must be masked
    seq:
      - id: raw_address
        type: u4
      - id: raw_upper_address
        type: u4
        if: _parent.message_control.address_64bit_capable
    instances:
      masked_address:
        value: >-
          (raw_address & 0xfffffffc) |
          (_parent.message_control.address_64bit_capable
            ? raw_upper_address << 32 : 0)
