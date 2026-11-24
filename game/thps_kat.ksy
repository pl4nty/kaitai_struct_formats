# Imported from https://github.com/DCxDemo/LegacyTHPS/blob/075ab69a9b2e7fcd042402cc2cccaf84ccb13e87/formats/thps_kat.ksy
meta:
  id: thps_kat
  title: Tony Hawk's Pro Skater KAT sample container
  application: Tony Hawk's Pro Skater
  file-extension: kat
  license: GPL-3.0-only
  endian: le

doc-ref: https://github.com/DCxDemo/LegacyThps/blob/master/formats/thps_kat.ksy

seq:
  - id: num_entries
    type: u4
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: num_entries
  
types:
  entry:
    seq:
      - id: channels
        type: u4
      - id: offset
        type: u4
      - id: size
        type: u4
      - id: freq
        type: u4
      - id: loop
        type: u4
      - id: bits
        type: u4
      - id: unk 
        type: u4
      - id: name # always null, assumed
        size: 16
    instances:
      data:
        pos: offset
        size: size
