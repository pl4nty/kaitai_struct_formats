# Imported from https://github.com/matthewturk/dispersing/blob/7ae6e02d575b01a92955b152376794e9ef13e0f5/dispersing/ksy_files/summoning_f.ksy
# Licence and copyright: see _community/README.md
meta:
  id: summoning_f
  file-extension: ""
  license: BSD-3-Clause
  endian: le
seq:
  - id: num_portraits
    type: u2
  - id: portraits_offset
    type: u2
  - id: unknown2
    type: u2
  - id: num_character
    type: u2
  - id: portraits
    type: portrait
    repeat: expr
    repeat-expr: num_portraits
  - id: characters
    type: character
    repeat: expr
    repeat-expr: num_character
types:
  portrait:
    seq:
      - id: col1
        type: u1
      - id: col2
        size: 4
      - id: portrait_id
        type: u1
      - id: col4
        type: u1
      - id: gender
        type: u1
  character:
    seq:
      - id: name
        size: 26
        type: str
        terminator: 0
        encoding: ASCII
      - id: portrait
        type: u1
      - id: strength
        type: u1
      - id: agility
        type: u1
      - id: endurance
        type: u1
      - id: accuracy
        type: u1
      - id: talent
        type: u1
      - id: power
        type: u1
      - id: spell_type
        type: u1
      - id: weapon_type
        type: u1
