# Imported from https://github.com/ucsdsysnet/dontlookup/blob/c15765a15740e9367df825f71c35ab224a8022e4/parser/parsers/gse/middle_of_pdu.ksy
# Licence and copyright: see _community/README.md
meta:
  id: middle_of_pdu
  file-extension: middle_of_pdu
  license: MIT
  endian: be
seq:
  - id: frag_id
    type: u1
  - id: data
    size-eos: true
