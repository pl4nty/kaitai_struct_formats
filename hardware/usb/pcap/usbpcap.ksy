meta:
  id: usbpcap
  title: USBPcap packet
  application: USBPcap
  license: Unlicense
  imports:
    - /hardware/usb/usb_urb_windows
    - /hardware/usb/pcap/usb_pcap_endpoint_number
    - /hardware/usb/usbd_status_windows
  -affected-by: [651, 703]
  endian: le
doc: |
  A packet as captured by [USBPcap](https://github.com/desowin/usbpcap) - an
  app to capture USB frames in Windows OSes. It is the content of a packet
  in a pcap file with the link type `usbpcap` (249).
doc-ref:
  - https://desowin.org/usbpcap/captureformat.html
  - https://github.com/desowin/usbpcap/blob/master/USBPcapDriver/include/USBPcap.h
seq:
  - id: header
    type: header
  - id: transfer_header
    type:
      switch-on: header.transfer_type
      cases:
        transfer_type::isochronous: isoch_header
        transfer_type::control: control_header
  - id: header_padding
    size: header.len_header - _io.pos
    if: header.len_header > _io.pos
  - id: data
    size: len_data
instances:
  len_available:
    value: _io.size - _io.pos
  is_truncated:
    value: header.len_data > len_available
    doc: |
      True if the capture holds less transfer data than the header
      announces, e.g. because of a snapshot length.
  len_data:
    value: 'is_truncated ? len_available : header.len_data'
types:
  header:
    -orig-id: USBPCAP_BUFFER_PACKET_HEADER
    seq:
      - id: len_header
        -orig-id: headerLen
        type: u2
        doc: |
          describes the total length, in bytes, of the header (including all
          transfer-specific header data).
      - id: io_request_packet_id
        -orig-id: irpId
        type: u8
        doc: |
          is merely a pointer to IRP casted to the UINT64. This value can be
          used to match the request with the response.
      - id: status
        type: usbd_status_windows
        doc: USB status code is valid only on return from host-controller.
      - id: urb_function
        -orig-id: function
        type: u2
        enum: usb_urb_windows::urb_function
      - id: io_request_info
        -orig-id: info
        type: info
      - id: bus
        type: u2
        doc: |
          bus (RootHub) number is the root hub identifier used to distingush
          between multiple root hubs.
      - id: device_address
        -orig-id: device
        type: u2
        doc: |
          is USB device number. This field is, contrary to the USB
          specification, 16-bit because Windows uses a 16-bit value for
          that matter. Check the DeviceAddress field of
          [USB_NODE_CONNECTION_INFORMATION](https://msdn.microsoft.com/en-us/library/windows/hardware/ff540090(v=vs.85).aspx).
      - id: endpoint_number
        -orig-id: endpoint
        type: usb_pcap_endpoint_number
      - id: transfer_type
        -orig-id: transfer
        type: u1
        enum: transfer_type
        doc: determines the transfer type and thus the header that follows.
      - id: len_data
        -orig-id: dataLength
        type: u4
        doc: |
          specifies the total length of transfer data to follow directly
          after the header.
  info:
    seq:
      - id: reserved
        type: b7
        doc: must be set to 0.
      - id: is_pdo_to_fdo
        -orig-id: USBPCAP_INFO_PDO_TO_FDO
        type: b1
        doc: it is 0 when IRP goes from FDO to PDO, 1 the other way round.
  isoch_header:
    -orig-id: USBPCAP_BUFFER_ISOCH_HEADER
    seq:
      - id: start_frame
        type: u4
      - id: num_packets
        -orig-id: numberOfPackets
        type: u4
      - id: error_count
        type: u4
      - id: packets
        -orig-id: packet
        type: isoch_packet
        repeat: expr
        repeat-expr: num_packets
    types:
      isoch_packet:
        -orig-id: USBPCAP_BUFFER_ISO_PACKET
        seq:
          - id: offset
            type: u4
            doc: Offset of the packet in the transfer data.
          - id: size
            -orig-id: length
            type: u4
          - id: status
            type: usbd_status_windows
  control_header:
    -orig-id: USBPCAP_BUFFER_CONTROL_HEADER
    seq:
      - id: stage
        type: u1
        enum: stage
    enums:
      stage:
        0:
          id: setup
          -orig-id: USBPCAP_CONTROL_STAGE_SETUP
        1:
          id: data
          -orig-id: USBPCAP_CONTROL_STAGE_DATA
        2:
          id: status
          -orig-id: USBPCAP_CONTROL_STAGE_STATUS
        3:
          id: complete
          -orig-id: USBPCAP_CONTROL_STAGE_COMPLETE
enums:
  transfer_type:
    0:
      id: isochronous
      -orig-id: USBPCAP_TRANSFER_ISOCHRONOUS
    1:
      id: interrupt
      -orig-id: USBPCAP_TRANSFER_INTERRUPT
    2:
      id: control
      -orig-id: USBPCAP_TRANSFER_CONTROL
    3:
      id: bulk
      -orig-id: USBPCAP_TRANSFER_BULK
    0xfe:
      id: irp_info
      -orig-id: USBPCAP_TRANSFER_IRP_INFO
    0xff:
      id: unknown
      -orig-id: USBPCAP_TRANSFER_UNKNOWN
