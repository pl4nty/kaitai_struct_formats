meta:
  id: masscan
  title: masscan binary scan results
  application: masscan
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /common/vlq_base128_be
    - /network/protocol_body
  encoding: ASCII
  endian: be
doc: |
  Results of a port scan in the binary format that the masscan tool writes
  with `-oB` and converts to other formats with `--readscan`.

  The file is a list of records, each with a type and a length in front.
  It starts with a 99-byte header, which is a record as well: its first
  two bytes, the letters "ma", stand for type 109 and length 97. A scan
  that ended normally closes the file with another record of that type.
doc-ref:
  - https://github.com/robertdavidgraham/masscan/blob/2895fa0acfe45983a3e9b2bbfadf25934c8d2c65/src/out-binary.c
  - https://github.com/robertdavidgraham/masscan/blob/2895fa0acfe45983a3e9b2bbfadf25934c8d2c65/src/in-binary.c
  - https://github.com/robertdavidgraham/masscan/blob/2895fa0acfe45983a3e9b2bbfadf25934c8d2c65/src/masscan-app.h
seq:
  - id: header
    size: 99
    type: header
  - id: records
    type: record
    repeat: until
    repeat-until: _.type == record_type::file_header or _io.eof
    if: not _io.eof
    doc: |
      The last record is the footer (type `file_header`), unless the scan
      was interrupted.
types:
  header:
    seq:
      - id: magic
        contents: masscan/1.1
      - id: metadata
        size-eos: true
        type: strz
        doc: |
          Lines of the form "key:value". The only one written so far is
          "s", the time the scan was started at as a Unix timestamp.
  record:
    seq:
      - id: type_raw
        type: vlq_base128_be
      - id: len_payload
        type: vlq_base128_be
      - id: payload
        size: 'type == record_type::banner4_short ? len_payload.value + 1 : len_payload.value'
        type:
          switch-on: type
          cases:
            'record_type::status_open': status
            'record_type::status_closed': status
            'record_type::banner3': banner3
            'record_type::banner4_short': banner4
            'record_type::banner4': banner4
            'record_type::status2_open': status2
            'record_type::status2_closed': status2
            'record_type::status2_arp': status2
            'record_type::banner9': banner9
            'record_type::status6_open': status6
            'record_type::status6_closed': status6
            'record_type::status6_arp': status6
            'record_type::banner6': banner6
    instances:
      type:
        value: type_raw.value
        enum: record_type
  status:
    seq:
      - id: timestamp
        type: u4
        doc: Unix timestamp.
      - id: ipv4_address
        size: 4
      - id: port
        type: u2
      - id: reason
        type: u1
        doc: For TCP, the flags of the response.
      - id: ttl
        type: u1
  status2:
    seq:
      - id: timestamp
        type: u4
        doc: Unix timestamp.
      - id: ipv4_address
        size: 4
      - id: ip_proto
        type: u1
        enum: protocol_body::protocol_enum
      - id: port
        type: u2
      - id: reason
        type: u1
        doc: For TCP, the flags of the response.
      - id: ttl
        type: u1
  status6:
    seq:
      - id: timestamp
        type: u4
        doc: Unix timestamp.
      - id: ip_proto
        type: u1
        enum: protocol_body::protocol_enum
      - id: port
        type: u2
      - id: reason
        type: u1
        doc: For TCP, the flags of the response.
      - id: ttl
        type: u1
      - id: ip_version
        type: u1
      - id: ip_address
        size: 16
        doc: IPv6 address.
  banner3:
    seq:
      - id: timestamp
        type: u4
        doc: Unix timestamp.
      - id: ipv4_address
        size: 4
      - id: port
        type: u2
      - id: app_proto
        type: u2
        enum: app_proto
      - id: banner
        size-eos: true
  banner4:
    seq:
      - id: timestamp
        type: u4
        doc: Unix timestamp.
      - id: ipv4_address
        size: 4
      - id: ip_proto
        type: u1
        enum: protocol_body::protocol_enum
      - id: port
        type: u2
      - id: app_proto
        type: u2
        enum: app_proto
      - id: banner
        size-eos: true
  banner9:
    seq:
      - id: timestamp
        type: u4
        doc: Unix timestamp.
      - id: ipv4_address
        size: 4
      - id: ip_proto
        type: u1
        enum: protocol_body::protocol_enum
      - id: port
        type: u2
      - id: app_proto
        type: u2
        enum: app_proto
      - id: ttl
        type: u1
      - id: banner
        size-eos: true
  banner6:
    seq:
      - id: timestamp
        type: u4
        doc: Unix timestamp.
      - id: ip_proto
        type: u1
        enum: protocol_body::protocol_enum
      - id: port
        type: u2
      - id: app_proto
        type: u2
        enum: app_proto
      - id: ttl
        type: u1
      - id: ip_version
        type: u1
      - id: ip_address
        size: 16
        doc: IPv6 address.
      - id: banner
        size-eos: true
enums:
  record_type:
    1: status_open
    2: status_closed
    3: banner3
    4:
      id: banner4_short
      doc: |
        Same as `banner4`, written by a version that set the length one
        byte too low.
    5: banner4
    6: status2_open
    7: status2_closed
    8: status2_arp
    9: banner9
    10: status6_open
    11: status6_closed
    12: status6_arp
    13: banner6
    109:
      id: file_header
      doc: The letter "m" of the header and footer.
  app_proto:
    0:
      id: none
      -orig-id: PROTO_NONE
    1:
      id: heur
      -orig-id: PROTO_HEUR
    2:
      id: ssh1
      -orig-id: PROTO_SSH1
    3:
      id: ssh2
      -orig-id: PROTO_SSH2
    4:
      id: http
      -orig-id: PROTO_HTTP
    5:
      id: ftp
      -orig-id: PROTO_FTP
    6:
      id: dns_version_bind
      -orig-id: PROTO_DNS_VERSIONBIND
    7:
      id: snmp
      -orig-id: PROTO_SNMP
    8:
      id: nbt_stat
      -orig-id: PROTO_NBTSTAT
    9:
      id: ssl3
      -orig-id: PROTO_SSL3
    10:
      id: smb
      -orig-id: PROTO_SMB
    11:
      id: smtp
      -orig-id: PROTO_SMTP
    12:
      id: pop3
      -orig-id: PROTO_POP3
    13:
      id: imap4
      -orig-id: PROTO_IMAP4
    14:
      id: udp_zero_access
      -orig-id: PROTO_UDP_ZEROACCESS
    15:
      id: x509_cert
      -orig-id: PROTO_X509_CERT
    16:
      id: html_title
      -orig-id: PROTO_HTML_TITLE
    17:
      id: html_full
      -orig-id: PROTO_HTML_FULL
    18:
      id: ntp
      -orig-id: PROTO_NTP
    19:
      id: vuln
      -orig-id: PROTO_VULN
    20:
      id: heartbleed
      -orig-id: PROTO_HEARTBLEED
    21:
      id: ticketbleed
      -orig-id: PROTO_TICKETBLEED
    22:
      id: vnc_rfb
      -orig-id: PROTO_VNC_RFB
    23:
      id: safe
      -orig-id: PROTO_SAFE
    24:
      id: memcached
      -orig-id: PROTO_MEMCACHED
    25:
      id: scripting
      -orig-id: PROTO_SCRIPTING
    26:
      id: versioning
      -orig-id: PROTO_VERSIONING
    27:
      id: coap
      -orig-id: PROTO_COAP
    28:
      id: telnet
      -orig-id: PROTO_TELNET
    29:
      id: rdp
      -orig-id: PROTO_RDP
    30:
      id: http_server
      -orig-id: PROTO_HTTP_SERVER
    31:
      id: end_of_list
      -orig-id: PROTO_end_of_list
