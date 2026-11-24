meta:
  id: sqlite4_varint
  title: SQLite4 variable-length unsigned integer (uvarint)
  application: SQLite4
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Variable-length encoding of a 64-bit unsigned integer into 1 to 9 bytes,
  designed for SQLite4 (also known as "uvarint"). Unlike LEB128-style
  varints, the length is determined entirely by the first byte A0, values
  compare in the same order as their encodings (memcmp), and up to 240 fits
  in a single byte:

  * A0 = 0..240: value is A0;
  * A0 = 241..248: value is 240 + 256 * (A0 - 241) + A1;
  * A0 = 249: value is 2288 + 256 * A1 + A2;
  * A0 = 250..255: value is the following (A0 - 247) bytes as a big-endian
    integer (3 to 8 bytes).

  Note that Go's `encoding/binary` "Uvarint" is a different (LEB128)
  encoding, see `vlq_base128_le`.
doc-ref:
  - https://sqlite.org/src4/doc/trunk/www/varint.wiki
  - https://github.com/mohae/uvarint/blob/master/uvarint.go
seq:
  - id: a0
    type: u1
  - id: a1
    type: u1
    if: a0 >= 241 and a0 <= 249
  - id: a2
    type: u1
    if: a0 == 249
  - id: big_endian_value
    type:
      switch-on: a0
      cases:
        250: b24
        251: b32
        252: b40
        253: b48
        254: b56
        255: b64
    if: a0 >= 250
instances:
  len:
    value: 'a0 <= 240 ? 1 : a0 <= 248 ? 2 : a0 == 249 ? 3 : a0 - 246'
    doc: Length of the encoded value in bytes.
  value:
    value: |
      (a0 <= 240 ? a0 :
      a0 <= 248 ? 240 + 256 * (a0 - 241) + a1 :
      a0 == 249 ? 2288 + 256 * a1 + a2 :
      big_endian_value).as<u8>
    doc: Decoded value.
