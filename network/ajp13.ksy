meta:
  id: ajp13
  title: Apache JServ Protocol version 1.3 (AJP13) packet
  application:
    - Apache Tomcat
    - mod_jk
    - mod_proxy_ajp
  license: CC0-1.0
  ks-version: '0.9'
  encoding: UTF-8
  endian: be
doc: |
  AJP13 is a binary protocol used by a web server (e.g. Apache httpd with
  mod_jk or mod_proxy_ajp) to forward requests to a servlet container (e.g.
  Apache Tomcat) over a persistent TCP connection, by default on port 8009.

  Every packet starts with a 2-byte magic and a 2-byte payload length.
  Packets from the web server to the container start with 0x1234, packets
  from the container to the web server with `AB`. The first payload byte is
  usually the message type, except for request body packets sent by the web
  server, which only contain a length-prefixed chunk of data. This spec
  treats a 0x1234 packet as a request body packet when its payload is empty
  or starts with a 16-bit length equal to the payload length minus 2.

  Strings are a 16-bit length followed by that many bytes and a terminating
  NUL byte, except that a length of 0xFFFF denotes a null string without any
  data. Common header names are sent as 16-bit codes 0xA0xx instead of
  strings.

  This spec describes one packet; a TCP stream is a sequence of them.
doc-ref:
  - https://tomcat.apache.org/connectors-doc/ajp/ajpv13a.html
  - https://github.com/apache/tomcat/blob/b4c09942b31bdba4b0124a02f89d5bf21deba435/java/org/apache/coyote/ajp/AjpProcessor.java
  - https://github.com/apache/tomcat/blob/b4c09942b31bdba4b0124a02f89d5bf21deba435/java/org/apache/coyote/ajp/AjpMessage.java
seq:
  - id: magic
    type: u2
    valid:
      any-of: [0x1234, 0x4142]
    doc: 0x1234 for packets sent to the container, 0x4142 (`AB`) for packets sent by it.
  - id: len_payload
    type: u2
  - id: payload
    size: len_payload
    type:
      switch-on: payload_kind
      cases:
        payload_kind::to_container: to_container_message
        payload_kind::request_body: request_body
        payload_kind::from_container: from_container_message
instances:
  is_to_container:
    value: magic == 0x1234
  body_len_check:
    pos: 4
    type: u2
    if: is_to_container and len_payload >= 2
  payload_kind:
    value: |
      not is_to_container ? payload_kind::from_container
        : len_payload == 0 or (len_payload >= 2 and body_len_check == len_payload - 2) ? payload_kind::request_body
        : payload_kind::to_container
    enum: payload_kind
types:
  ajp_string:
    seq:
      - id: len_value
        type: u2
        doc: 0xFFFF for a null string.
      - id: value
        size: len_value
        type: str
        if: not is_null
      - id: terminator
        contents: [0]
        if: not is_null
    instances:
      is_null:
        value: len_value == 0xffff
  to_container_message:
    seq:
      - id: prefix_code
        type: u1
        enum: to_container_type
      - id: body
        type:
          switch-on: prefix_code
          cases:
            to_container_type::forward_request: forward_request
  request_body:
    doc: |
      Chunk of the request body, sent after a forward request with a
      non-zero content length or in response to a "get body chunk" message.
      An empty packet signals the end of the body.
    seq:
      - id: len_data
        type: u2
        if: not _io.eof
      - id: data
        size: len_data
        if: not _io.eof
  forward_request:
    seq:
      - id: method
        type: u1
        enum: method
      - id: protocol
        type: ajp_string
      - id: req_uri
        type: ajp_string
      - id: remote_addr
        type: ajp_string
      - id: remote_host
        type: ajp_string
      - id: server_name
        type: ajp_string
      - id: server_port
        type: u2
      - id: is_ssl
        type: u1
      - id: num_headers
        type: u2
      - id: headers
        type: request_header
        repeat: expr
        repeat-expr: num_headers
      - id: attributes
        type: attribute
        repeat: until
        repeat-until: _.code == attribute_code::are_done
  request_header:
    seq:
      - id: name
        type: header_name
      - id: value
        type: ajp_string
  header_name:
    doc: Either a 16-bit code 0xA0xx for a common header, or a string.
    seq:
      - id: code
        type: u2
        if: is_code
      - id: name
        type: ajp_string
        if: not is_code
    instances:
      first_byte:
        pos: _io.pos
        type: u1
      is_code:
        value: first_byte == 0xa0
  attribute:
    seq:
      - id: code
        type: u1
        enum: attribute_code
      - id: name
        type: ajp_string
        if: code == attribute_code::req_attribute
        doc: Name of a generic request attribute (e.g. an environment variable).
      - id: key_size
        type: u2
        if: code == attribute_code::ssl_key_size
      - id: value
        type: ajp_string
        if: code != attribute_code::are_done and code != attribute_code::ssl_key_size
  from_container_message:
    seq:
      - id: prefix_code
        type: u1
        enum: from_container_type
      - id: body
        type:
          switch-on: prefix_code
          cases:
            from_container_type::send_body_chunk: send_body_chunk
            from_container_type::send_headers: send_headers
            from_container_type::end_response: end_response
            from_container_type::get_body_chunk: get_body_chunk
  send_body_chunk:
    seq:
      - id: len_chunk
        type: u2
      - id: chunk
        size: len_chunk
      - id: terminator
        size-eos: true
        doc: Tomcat appends a NUL byte after the chunk.
  send_headers:
    seq:
      - id: status_code
        type: u2
      - id: status_message
        type: ajp_string
      - id: num_headers
        type: u2
      - id: headers
        type: response_header
        repeat: expr
        repeat-expr: num_headers
  response_header:
    seq:
      - id: name
        type: header_name
      - id: value
        type: ajp_string
  end_response:
    seq:
      - id: reuse
        type: u1
        doc: Non-zero if the connection can be reused for another request.
  get_body_chunk:
    seq:
      - id: requested_length
        type: u2
enums:
  payload_kind:
    0: to_container
    1: request_body
    2: from_container
  to_container_type:
    2: forward_request
    7: shutdown
    8: ping
    10: cping
  from_container_type:
    3: send_body_chunk
    4: send_headers
    5: end_response
    6: get_body_chunk
    9: cpong_reply
  method:
    1: options
    2: get
    3: head
    4: post
    5: put
    6: delete
    7: trace
    8: propfind
    9: proppatch
    10: mkcol
    11: copy
    12: move
    13: lock
    14: unlock
    15: acl
    16: report
    17: version_control
    18: checkin
    19: checkout
    20: uncheckout
    21: search
    22: mkworkspace
    23: update
    24: label
    25: merge
    26: baseline_control
    27: mkactivity
  attribute_code:
    0x01: context
    0x02: servlet_path
    0x03: remote_user
    0x04: auth_type
    0x05: query_string
    0x06: route
    0x07: ssl_cert
    0x08: ssl_cipher
    0x09: ssl_session
    0x0a: req_attribute
    0x0b: ssl_key_size
    0x0c: secret
    0x0d: stored_method
    0xff: are_done
