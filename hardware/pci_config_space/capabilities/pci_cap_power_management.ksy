meta:
  id: pci_cap_power_management
  title: PCI power management capability
  license: 0BSD
  endian: le

doc: |
  PCI Power Management capability, capability ID 0x01. Parsed from the
  byte after the next-capability pointer.

doc-ref: |
  PCI Bus Power Management Interface Specification Revision 1.0
  p20, 3.2 Power Management Register Block Definition

  PCI EXPRESS BASE SPECIFICATION, REV. 3.0
  p601, 7.6.  PCI Power Management Capability Structure

# TODO: update to v1.2
# TODO: re-check PCIe spec

seq:
  - id: capabilities
    -orig-id: PMC
    type: capabilities
  - id: control_status
    -orig-id: PMCSR
    type: control_status
  - id: bridge_support_extensions
    -orig-id: PMCSR_BSE
    type: bridge_support_extensions
  - id: data
    type: u1

types:
  capabilities:
    seq:
      # bits 7:0
      - id: aux_current_lower
        type: b2
      - id: device_specific_initialization
        -orig-id: DSI
        type: b1
      - id: auxiliary_power_source
        # phased out in v1.1
        type: b1
      - id: pme_clock
        type: b1
      - id: version
        type: b3
      # bits 15:8
      - id: pme_support
        type: b5
      - id: d2_support
        type: b1
      - id: d1_support
        type: b1
      - id: aux_current_upper
        type: b1
    instances:
      aux_current:
        value: aux_current_lower | (aux_current_upper.to_i << 2)
        doc: Aux_Current, PMC bits 8:6.

  control_status:
    seq:
      # bits 7:0
      - id: reserved0
        type: b6
      - id: power_state
        type: b2
        enum: power_state
      # bits: 15:8
      - id: pme_status
        type: b1
      - id: data_scale
        type: b2
      - id: data_select
        type: b4
      - id: pme_enable
        -orig-id: PME_En
        type: b1

  bridge_support_extensions:
    seq:
      # bits 7:0
      - id: bus_power_clock_control_enable
        -orig-id: BPCC_En
        type: b1
      - id: b2_b3_support
        -orig-id: B2_B3#
        type: b1
      - id: reserved
        type: b6

enums:
  power_state:
    0: d0
    1: d1
    2: d2
    3: d3_hot
