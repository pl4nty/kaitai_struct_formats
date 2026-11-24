# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/mpint.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ssh_mpint
  title: SSH mpint (big integer)
  xref:
    rfc: 4251
  license: CC0-1.0
  endian: be
doc: Big integers serialization format used by SSH.
doc-ref: 'https://tools.ietf.org/html/rfc4251#section-5'
seq:
  - id: len_body
    type: u4
    valid:
      expr: _ <= _io.size - _io.pos
  - id: body
    size: len_body
instances:
  length_in_bits:
    value: (len_body - 1) * 8
    doc: |
      Length of big integer in bits. In OpenSSH sources, this corresponds to
      `BN_num_bits` function.
