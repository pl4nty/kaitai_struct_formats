# Imported from https://github.com/ucsdsysnet/dontlookup/blob/c15765a15740e9367df825f71c35ab224a8022e4/parser/parsers/gse/whole_pdu.ksy
meta:
  id: dvb_gse_whole_pdu
  file-extension: whole_pdu
  license: MIT
  endian: be
params: 
  - id: label_type_indicator
    type: b2
seq: 
  - id: protocol_type
    type: b16
  - id: six_byte_label
    size: 6
    if: label_type_indicator == 0b00
  - id: three_byte_label
    size: 3
    if: label_type_indicator == 0b01
  - id: data
    size-eos: true
