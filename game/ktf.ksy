# Imported from https://github.com/ascenttree/kaitai-structs/blob/8cefaae9b8d13f181318f1ef35c3a9994ec6c2e3/ktf/ktf.ksy
meta:
  id: ktf
  title: "KTF localisation file (KAEDE!)"
  file-extension: ktf
  license: LicenseRef-All-Rights-Reserved
  imports:
    - ktf_net_string
  endian: le
seq:
  - id: magic
    contents: KAEDE!
  - id: version
    type: u4
    valid: 1
  - id: fallback_locale_id
    type: u4
  - id: num_locales
    type: u4
  - id: locales
    type: locale
    repeat: expr
    repeat-expr: num_locales
types:
  locale:
    seq:
      - id: id
        type: u4
      - id: code
        type: ktf_net_string
      - id: localised_name
        type: ktf_net_string
      - id: num_strings
        type: u4
      - id: strings
        type: locale_string
        repeat: expr
        repeat-expr: num_strings
  locale_string:
    seq:
      - id: name
        type: ktf_net_string
      - id: value
        type: ktf_net_string
