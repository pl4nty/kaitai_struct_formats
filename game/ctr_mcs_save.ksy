# Imported from https://github.com/CTR-tools/CTR-tools/blob/8edc826ccab49099776f6431e25b4136a2ecbec3/formats/ctr_mcs_save.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ctr_mcs_save
  title: CTR save slot
  application: Crash Team Racing
  file-extension: mcs
  license: GPL-2.0-only
  endian: le

seq:
  - id: header
    size: 128
  
  - id: unk88
    type: u4
    
  - id: title
    size: 16*6-4
    type: strz
    encoding: Shift_JIS
    
  - id: icon
    type: icon
    
  - id: saves
    type: slot
    repeat: expr
    repeat-expr: 4
    
  - id: unk
    size: 16
    
  - id: levels
    type: level_times_slot
    repeat: expr
    repeat-expr: 18
    
  - id: unk2
    type: u2
    repeat: expr
    repeat-expr: 15
  
  - id: skip
    size: 0x88
    
  - id: checksum
    type: u2
    
types:
  icon:
    seq:
      - id: palette
        type: u2
        repeat: expr
        repeat-expr: 16
      - id: data
        size: 16*8

  slot:
    seq:
      - id: data
        size: 16 * 5
  
  level_times_slot:
    seq:
      - id: trial_slots
        type: level_time
        repeat: expr
        repeat-expr: 12
      - id: unk
        type: u4
        
  level_time:
    seq:
      - id: time
        type: u4
      - id: name
        size: 0x12
        type: strz
        encoding: ASCII
      - id: char
        type: u2
