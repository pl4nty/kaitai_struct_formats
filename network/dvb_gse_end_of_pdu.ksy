# Imported from https://github.com/ucsdsysnet/dontlookup/blob/c15765a15740e9367df825f71c35ab224a8022e4/parser/parsers/gse/end_of_pdu.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dvb_gse_end_of_pdu
  file-extension: end_of_pdu
  license: MIT
  endian: be
  
seq: 
  - id: frag_id
    type: u1
  - id: data
    size: _io.size-5
  - id: crc
    size: 4
