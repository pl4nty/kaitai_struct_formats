meta:
  id: pci_cap_vendor_specific
  title: PCI vendor-specific capability
  license: 0BSD
  endian: le

doc: |
  Vendor Specific capability, capability ID 0x09. Parsed from the byte
  after the next-capability pointer.

doc-ref: |
  PCI LOCAL BUS SPECIFICATION, REV. 3.0
  p330, H. Capability IDs

seq:
  - id: length
    type: u1
    doc: Length of the capability structure, counted from the capability ID byte.
  - id: data
    size: length - 3
