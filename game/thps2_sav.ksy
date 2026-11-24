# Imported from https://github.com/DCxDemo/LegacyTHPS/blob/075ab69a9b2e7fcd042402cc2cccaf84ccb13e87/formats/thps2_sav.ksy
meta:
  id: thps2_sav
  title: Tony Hawk's Pro Skater 2 (PC) save file
  application: Tony Hawk's Pro Skater 2 (PC)
  file-extension: sav
  license: GPL-3.0-only
  endian: le

doc-ref: https://github.com/DCxDemo/LegacyTHPS/blob/master/formats/thps2_sav.ksy

seq:
  - id: magic # "SC" - magic word
    type: u2
  - id: version # 0x112 - save file version?
    type: u2
  - id: name
    size: 0x5C
    type: strz
    encoding: ASCII
  - id: icon # likely memcard icon leftover from psx?
    size: 0x1A4
  - id: char_career
    type: char_career_entry
    repeat: expr
    repeat-expr: 20 # 16 chars + 4 cas ! 24 in korean thps
  - id: score_table
    type: score_table_level
    repeat: expr
    repeat-expr: 14
  - id: gap_mask
    type: gap_mask
    repeat: expr
    repeat-expr: 13 # 8 levels + 2 hidden + 3 legacy?
  - id: skipdata
    size: 0x1a0
  - id: horse_name
    size: 16
    type: strz
    encoding: ASCII
  - id: cas
    type: cas_entry
    repeat: expr
    repeat-expr: 4

types:
  char_career_entry:
    seq:
      - id: career_flags
        type: u4
      - id: total_cash # total amount of money
        type: u4
      - id: remaining_cash # cash available to spend
        type: u4  
      - id: level_flags # 2 bytes per level, 10 bits - goals, 3 bits - medals, maybe more?
        type: u2
        repeat: expr
        repeat-expr: 13
      - id: unk
        size: 10
      - id: value2
        type: u4
      - id: decks # bit flag per unlocked deck
        type: u4
      - id: stats # just byte per stat
        size: 10
      - id: rest_of_data # more data
        size: 0xc2

  score_table_level:
    seq: 
      - id: entries
        type: score_table_entry
        repeat: expr
        repeat-expr: 8

  score_table_entry:
    seq:
      - id: label
        size: 3
        type: str
        encoding: ASCII
      - id: skater
        type: u1
      - id: score
        type: u4

  gap_mask: # allows for 12*8=96 gaps per level
    seq:
      - id: data
        size: 12

  cas_entry:
    seq:
      - id: name
        size: 16
        type: strz
        encoding: ASCII
      - id: hometown
        size: 16
        type: strz
        encoding: ASCII
      - id: data
        size: 0x60
