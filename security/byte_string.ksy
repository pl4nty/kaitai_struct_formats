# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/byte_string.ksy
# Licence and copyright: see _community/README.md
meta:
  id: byte_string
  title: SSH string (bytes)
  xref:
    rfc: 4251
  license: CC0-1.0
  endian: be
doc: |
  An integer-prefixed byte array designed to be used for arbitrary data
  that is not expected to be a string.
-webide-representation: '{value}'
seq:
  - id: len_data
    type: u4
    valid:
      expr: _ <= _io.size - _io.pos
  - id: data
    size: len_data
