# Imported from https://github.com/ucsdsysnet/dontlookup/blob/c15765a15740e9367df825f71c35ab224a8022e4/parser/parsers/gse/gse_standard.ksy
meta:
  id: dvb_gse
  file-extension: gse_standard
  license: MIT
  imports:
    - dvb_gse_start_of_pdu
    - dvb_gse_middle_of_pdu
    - dvb_gse_end_of_pdu
    - dvb_gse_whole_pdu
  endian: be
seq:
  - id: start_and_end_indicators
    type: b2
    enum: se
  - id: label_type_indicator
    type: b2
  - id: gse_length
    type: b12
  - id: payload
    size: gse_length
    type:
      switch-on: start_and_end_indicators
      cases:
        'se::start': dvb_gse_start_of_pdu(label_type_indicator)
        'se::middle': dvb_gse_middle_of_pdu
        'se::end': dvb_gse_end_of_pdu
        'se::whole': dvb_gse_whole_pdu(label_type_indicator)
    if: not is_padding
instances:
  is_padding:
    value: start_and_end_indicators == se::middle and (label_type_indicator == 0b00) and (gse_length == 0x000)
  is_start:
    value: start_and_end_indicators == se::start
  is_middle:
    value: start_and_end_indicators == se::middle
  is_end: 
    value: start_and_end_indicators == se::end
  is_whole:
    value: start_and_end_indicators == se::whole
enums:
  se:
    0: middle
    1: end
    2: start
    3: whole
