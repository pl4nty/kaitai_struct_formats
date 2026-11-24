# Imported from https://github.com/pompierninja/yaconstrip/blob/b18c60015b35dcf446894af1954d42ae886601e3/kaitai/publisher_tc_segment.ksy
meta:
  id: iab_tcf_publisher_tc
  title: 'Publisher Purposes Transparency and Consent'
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: segment_type
    type: b3
  - id: pub_purposes_consent
    type: b1
    repeat: expr
    repeat-expr: 24
  - id: pub_purposes_li_transparency
    type: b1
    repeat: expr
    repeat-expr: 24
  - id: num_custom_purposes
    type: b6
  - id: custom_purposes_consent
    type: b1
    repeat: expr
    repeat-expr: num_custom_purposes
    if: num_custom_purposes > 0
  - id: custom_purposes_li_transparency
    type: b1
    repeat: expr
    repeat-expr: num_custom_purposes
    if: num_custom_purposes > 0
