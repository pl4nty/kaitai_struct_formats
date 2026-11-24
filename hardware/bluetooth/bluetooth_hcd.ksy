meta:
  id: bluetooth_hcd
  title: Bluetooth controller firmware patch (HCD)
  file-extension: hcd
  xref:
    ieee: 802.15.1
    wikidata: Q39531
  license: Unlicense
  imports:
    - control/bluetooth_control_command
    - bluetooth_vendors_ids
  endian: le
doc: |
  Firmware patch for a Bluetooth controller in the form of the HCI commands
  that load it, as shipped for Broadcom and Cypress chips: the commands are
  stored one after another without the packet type byte of the UART
  transport. Loading tools send them to the controller in order.

  The meaning of vendor-specific commands depends on the maker of the
  chip, which the file does not name, so it has to be passed in.
doc-ref:
  - https://www.bluetooth.org/docman/handlers/downloaddoc.ashx?doc_id=478726
  - https://software-dl.ti.com/simplelink/esd/simplelink_cc13x2_sdk/1.60.00.29_new/exports/docs/ble5stack/vendor_specific_guide/BLE_Vendor_Specific_HCI_Guide/hci_interface.html
  - https://www.ti.com/lit/ug/swru442b/swru442b.pdf?ts=1594902336269
  - https://community.nxp.com/docs/DOC-341764
params:
  - id: vendor
    type: u2
    enum: bluetooth_vendors_ids::vendor
seq:
  - id: commands
    type: bluetooth_control_command(vendor)
    repeat: eos
