# Imported from https://github.com/radio-astro-tools/casa-formats-specification/blob/67d16c3dcfccba74b4ec2c0ed75c80b1cc02b2a4/casaio/src/casaio/tablestream/templates/dtype.ksy
meta:
  id: casa_dtype
  file-extension: dtype
  license: LicenseRef-All-Rights-Reserved
  endian: be

doc: |
  User defined version of base numerical data types. This will allow for the
  compilation of languages like c++ and rust

types:
  uint1:
    seq:
      - id: value
        type: u1

  uint2:
    seq:
      - id: value
        type: u2

  uint4:
    seq:
      - id: value
        type: u4

  uint8:
    seq:
      - id: value
        type: u8

  int1:
    seq:
      - id: value
        type: s1

  int2:
    seq:
      - id: value
        type: s2

  int4:
    seq:
      - id: value
        type: s4

  int8:
    seq:
      - id: value
        type: s8

  float4:
    seq:
      - id: value
        type: f4

  float8:
    seq:
      - id: value
        type: f8

  bool1:
    seq:
      - id: value
        type: b1

  complex8:
    seq:
      - id: real
        type: f4
      - id: imaginary
        type: f4

  complex16:
    seq:
      - id: real
        type: f8
      - id: imaginary
        type: f8

  string:
    seq:
      - id: length
        type: u4
      - id: value
        size: length
        type: str
        encoding: ASCII
