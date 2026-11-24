# Imported from https://github.com/OK-DMR/dmr-kaitai/blob/7489ff1a8b418e3d37e2a0268acbaf2710543d93/okdmr/kaitai/etsi/dmr_ip_udp.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dmr_ip_udp
  title: DMR IP/UDP PDU
  license: AGPL-3.0-only
  endian: le
doc: ETSI TS 102 361-3 V1.3.1, section 7, PDUs
enums:
  source_ip_address_ids:
    0b0000: radio_network
    0b0001: usb_ethernet_interface_network
  destination_ip_address_ids:
    0b0000: radio_network
    0b0001: usb_ethernet_interface_network
    0b0010: group_network
  udp_port_ids:
    0b0000000: present_in_extended_header
    0b0000001: utf16be_text_message_port_5016
    0b0000010: location_interface_protocol
types:
  udp_ipv4_compressed_header:
    doc: 7.2.3 UDP/IPv4 Compressed Header, Table 7.14
    seq:
      - id: ipv4_identification
        size: 2
      - id: source_ip_address_id
        type: b4
        enum: source_ip_address_ids
        doc: SAID
      - id: destination_ip_address_id
        type: b4
        enum: destination_ip_address_ids
        doc: DAID
      - id: header_compression_opcode_msb
        type: b1
      - id: udp_source_port_id
        type: b7
        enum: udp_port_ids
        doc: SPID
      - id: header_compression_opcode_lsb
        type: b1
      - id: udp_destination_port_id
        type: b7
        enum: udp_port_ids
        doc: DPID
      - id: udp_source_port
        size: 2
        if: udp_source_port_id == udp_port_ids::present_in_extended_header
      - id: udp_destination_port
        size: 2
        if: udp_destination_port_id == udp_port_ids::present_in_extended_header
      - id: user_data
        size-eos: true
