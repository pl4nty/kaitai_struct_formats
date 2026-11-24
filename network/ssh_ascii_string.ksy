# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/ascii_string.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ssh_ascii_string
  title: SSH string (ASCII)
  xref:
    rfc: 4251
  license: CC0-1.0
  endian: be
doc: |
  A integer-prefixed string in ASCII encoding. All internal strings
  are represented in ASCII.
doc-ref: 'https://tools.ietf.org/html/rfc4251#section-5'
-webide-representation: '{value}'
seq:
  - id: len
    type: u4
    valid:
      expr: _ <= 65535 and _ <= _io.size - _io.pos
  - id: value
    size: len
    type: str
    encoding: ASCII
