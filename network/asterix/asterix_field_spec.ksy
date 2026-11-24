meta:
  id: asterix_field_spec
  title: ASTERIX field specification
  license: GPL-3.0-only
  ks-version: 0.9
  endian: be

doc: |
  Implementation of ASTERIX format.

  From Eurocontrol Asterix web page at
  https://www.eurocontrol.int/asterix

  The field_spec type, is an encapsulation of the Fiel Spec field. This is also
  used in the Compound format field as a primary part of the field.

seq:
  - id: octects
    type: bits_t
    repeat: until
    repeat-until: not _.fx

instances:
  size:
    value: 7 * octects.size

types:

  bits_t:

    seq:
      - id: bits
        type: b1
        repeat: expr
        repeat-expr: 7
      - id: fx
        type: b1
