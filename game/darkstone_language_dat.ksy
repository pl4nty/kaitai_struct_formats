# Imported from https://github.com/Game3DEE/darkstone/blob/afc3261693b91fcd371e975889d788dfded04311/src/kaitai/language.ksy
meta:
  id: darkstone_language_dat
  file-extension: dat
  license: MIT
  encoding: UTF-8
  endian: le

seq:
  - contents: [ 1, 0 ]
  - id: text_count
    type: s4
  - id: texts
    type: text
    repeat: expr
    repeat-expr: text_count

enums:
  text_sections:
    0: french
    1: english
    2: german
    3: spanish
    4: swedish
    5: italian
    6: unused_language_slot
    7: agent_name  #OFF = Off/Narrator, PERSO = Player character speaks.
    8: quest_name
    9: gender
    10: description
    11: voice_file

types:
  string:
    seq:
      - id: length
        type: u4
      - id: text
        size: length
        type: strz
    
  text:
    seq:
      - id: version
        type: u2
      - id: val0
        type: u4
      - id: id
        type: string
      - id: section_count
        type: u4
      - id: sections
        type: string
        repeat: expr
        repeat-expr: section_count
