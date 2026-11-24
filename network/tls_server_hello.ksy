# Imported from https://github.com/elsamuko/hello/blob/e34f756c8ee496571cbf458c70585954df74a03e/src/kaitai/tls_server_hello.ksy
meta:
  id: tls_server_hello
  title: TLS ServerHello message
  license: MIT
  endian: be

seq:
  - id: type
    contents: [0x02]

  - id: size
    type: b24

  - id: version
    type: version

  - id: random
    type: random

  - id: session_id
    type: session_id

  - id: cipher_suite
    type: u2

  - id: compression_method
    type: u1

  - id: extensions
    type: extensions
    if: _io.eof == false

types:
  version:
    seq:
      - id: major
        type: u1

      - id: minor
        type: u1

  random:
    seq:
      - id: gmt_unix_time
        type: u4

      - id: random
        size: 28

  session_id:
    seq:
      - id: len
        type: u1

      - id: sid
        size: len

  extensions:
    seq:
      - id: len
        type: u2

      - id: extensions
        type: extension
        repeat: eos

  extension:
    seq:
      - id: type
        type: u2

      - id: len
        type: u2

      - id: body
        size: len
