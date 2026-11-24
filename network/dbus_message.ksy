meta:
  id: dbus_message
  title: D-Bus message
  application: D-Bus
  xref:
    wikidata: Q768923
  license: CC0-1.0
  ks-version: '0.11'
  encoding: UTF-8
doc: |
  A message of the D-Bus inter-process communication system, as sent
  on the wire (and stored in pcap files with link type 231,
  LINKTYPE_DBUS, e.g. by dbus-dump or dbus-monitor --pcap).

  A message consists of a header with the fixed signature
  `yyyyuua(yv)` (endianness flag, message type, flags, protocol
  version, body length, serial, array of header fields), padding to an
  8-byte boundary, and the body. The byte order of everything after the
  first byte is given by the endianness flag. Values are aligned to
  their natural size relative to the start of the message.

  This spec decodes the header including all header fields defined by
  the specification (whose values are strings, object paths,
  signatures or 32-bit integers); the body is kept as raw bytes, since
  decoding it requires interpreting the `signature` header field.
doc-ref:
  - https://dbus.freedesktop.org/doc/dbus-specification.html#message-protocol-messages
  - https://github.com/mvidner/dbus-dump/blob/5e3213a8583cae8ea4cfb676660ca6389d4b98cb/lib/pcap/savefile.rb
seq:
  - id: endianness
    type: u1
    enum: endianness
    valid:
      any-of:
        - endianness::little
        - endianness::big
  - id: message
    type: message
types:
  message:
    meta:
      endian:
        switch-on: _root.endianness
        cases:
          endianness::little: le
          endianness::big: be
    seq:
      - id: message_type
        type: u1
        enum: message_type
      - id: flags
        type: flags
      - id: protocol_version
        type: u1
        doc: Major protocol version; 1.
      - id: len_body
        type: u4
      - id: serial
        type: u4
      - id: len_header_fields
        type: u4
      - id: header_fields
        size: len_header_fields
        type: header_fields
      - id: header_padding
        size: (8 - (16 + len_header_fields) % 8) % 8
      - id: body
        size: len_body
    types:
      flags:
        meta:
          bit-endian: le
        seq:
          - id: no_reply_expected
            type: b1
          - id: no_auto_start
            type: b1
          - id: allow_interactive_authorization
            type: b1
          - id: reserved
            type: b5
      header_fields:
        doc: |
          The array starts at offset 16 of the message, an 8-byte boundary,
          so alignment can be computed relative to this substream.
        seq:
          - id: fields
            type: header_field
            repeat: eos
      header_field:
        seq:
          - id: alignment
            size: (8 - _io.pos % 8) % 8
            doc: Each field is a STRUCT, aligned to 8 bytes.
          - id: code
            type: u1
            enum: header_field_code
          - id: value_signature
            type: dbus_signature
            doc: Signature of the variant value (a single complete type).
          - id: value_alignment
            size: 'value_signature.value == "g" ? 0 : (4 - _io.pos % 4) % 4'
          - id: value
            type:
              switch-on: value_signature.value
              cases:
                '"s"': dbus_string
                '"o"': dbus_string
                '"g"': dbus_signature
                '"u"': dbus_uint32
      dbus_string:
        doc: STRING or OBJECT_PATH; aligned to 4 bytes.
        seq:
          - id: len_value
            type: u4
          - id: value
            size: len_value
            type: str
          - id: terminator
            contents: [0]
      dbus_uint32:
        doc: UINT32; aligned to 4 bytes.
        seq:
          - id: value
            type: u4
      dbus_signature:
        seq:
          - id: len_value
            type: u1
          - id: value
            size: len_value
            type: str
          - id: terminator
            contents: [0]
enums:
  endianness:
    0x6c: little
    0x42: big
  message_type:
    0: invalid
    1: method_call
    2: method_return
    3: error
    4: signal
  header_field_code:
    0: invalid
    1: path
    2: interface
    3: member
    4: error_name
    5: reply_serial
    6: destination
    7: sender
    8: signature
    9: unix_fds
