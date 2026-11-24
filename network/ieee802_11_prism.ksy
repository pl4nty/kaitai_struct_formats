meta:
  id: ieee802_11_prism
  title: prism II headers for 802.11 capture
  xref:
    ieee: 802.11
    wikidata: Q7245672
  license: Unlicense
  encoding: ASCII
  endian: le
doc: |
  Prism II headers are usually used by wlan cards based on
  Intersil/Conexant/Broadcom [Prism
  II](https://en.wikipedia.org/wiki/Prism_(chipset)) and Proxim Wireless/Lucent
  ORiNOCO.
  Disclaimer: AFAIK there is no official spec publicly available, most of the
  specs publicly available are reverse-engineered and incorporate their authors
  beliefs.

doc-ref:
  - https://www.tcpdump.org/linktypes/LINKTYPE_IEEE802_11_PRISM.html
  - http://www.martin.cc/linux/prism
  - https://github.com/NetBSD/src/blob/254d96fc6f162e5bf73da95029e7c6f3c9c6fd2c/sys/dev/ic/wi.c
  - https://github.com/freebsd/freebsd/tree/c71e73b0fbd8b142ebb4a933bb0e93ec2b0d830e/sys/dev/wi
  - https://github.com/wireshark/wireshark/blob/3a514caaf1e3b36eb284c3a566d489aba6df5392/epan/dissectors/packet-ieee80211-prism.c

seq:
  - id: message_code
    type: u4
  - id: size
    type: u4
  - id: device_name
    size: 16
    type: strz
  - id: fields
    size: fields_size
    type: fields
  - id: body
    size-eos: true
instances:
  header_size:
    value: 4 + 4 + 16
  fields_size:
    value: size - header_size
types:
  fields:
    seq:
      - id: fields
        type: field
        repeat: eos
    types:
      field:
        seq:
          - id: did
            -orig-id: DID
            type: u4
            doc: |
              Field identifier. Its layout depends on the message code: for
              message code 0x41 the values are 0x0000N041, for message code
              0x44 they are 0x000N0044, where N is the field type (see
              `type`).
          - id: status
            type: u2
            doc: 0 if the value of the field is supplied, 1 if it is not.
          - id: len_value
            -orig-id: length
            type: u2
            doc: Length of `value`; almost always 4.
          - id: value
            size: len_value
            type:
              switch-on: type
              cases:
                'type::host_time': u4 # in 10ms units, according to Cris Martin
                'type::mac_time': u4 # In micro-seconds, according to Cris Martin
                'type::channel': u4
                'type::rssi': s4
                'type::signal_quality': u4
                'type::signal': s4
                'type::noise': s4
                'type::data_rate': data_rate
                'type::direction': direction
                'type::frame_length': u4
        instances:
          did_code:
            value: did & 0xff
            doc: Low byte of `did`; equal to the message code (0x41 or 0x44).
          type:
            value: 'did_code == 0x44 ? (did >> 16) & 0xf : (did >> 12) & 0xf'
            enum: type
          is_supplied:
            value: status == 0
        types:
          data_rate:
            seq:
              - id: rate_500khz
                type: u4
                doc: Data rate in units of 500 kHz (i.e. 500 kbit/s).
            instances:
              rate_kbps:
                value: rate_500khz * 500
                doc: Data rate in kbit/s.
          direction:
            seq:
              - id: value
                type: u4
                enum: direction
                -affected-by: 88
            enums:
              direction:
                0:
                  id: receive
                1:
                  id: transmit
enums:
  type:
    0x1: host_time
    0x2: mac_time
    0x3: channel
    0x4:
      id: rssi
      doc: Signed value, apparently in dBm.
    0x5: signal_quality
    0x6:
      id: signal
      doc: Signed value, apparently in dBm.
    0x7:
      id: noise
      doc: Signed value, apparently in dBm.
    0x8:
      id: data_rate
      doc: In units of 500 kHz.
    0x9:
      id: direction
      -orig-id: is_tx
      doc: 0 = received packet, 1 = transmitted packet.
    0xa: frame_length
