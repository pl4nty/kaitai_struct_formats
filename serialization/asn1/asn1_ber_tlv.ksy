meta:
  id: asn1_ber_tlv
  title: ASN.1 BER TLV
  file-extension: tlv
  xref:
    justsolve: BER
    wikidata: Q2738854
  license: CC0-1.0
  
  imports:
    - asn1_ber_tag
    - asn1_ber_length

doc: Basic Encoding Rules (BER) TLV formatting rules.
doc-ref: https://en.wikipedia.org/wiki/X.690#BER_encoding X.690 BER encoding


seq:
  - id: tag
    type: asn1_ber_tag
  - id: length
    type: asn1_ber_length
  - id: value_primitive
    type: u1
    repeat: expr
    repeat-expr: length.val_len
    if: (tag.form == tag_form::primitive_form)
  - id: constructed_body
    size: length.val_len
    type: constructed
    if: (tag.form == tag_form::constructed_form)
    doc: The contents octets of a constructed value, holding its child TLVs.

instances:
  value_constructed:
    value: constructed_body.items
    if: (tag.form == tag_form::constructed_form)
    doc: The child TLVs of a constructed value.

types:
  constructed:
    seq:
      - id: items
        type: asn1_ber_tlv
        repeat: eos

enums:
  tag_form:
    0: primitive_form # 'Primitive Form - The contents octets directly encode the value.'
    1: constructed_form # 'Constructed Form - The contents octets contain 0, 1, or more encodings.'
