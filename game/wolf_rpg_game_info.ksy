# Imported from https://github.com/whitearine/wolf-rpg-kaitai/blob/42cd3f6a1d31fb6d0da1042c47c4ec692d7217a8/game_info.ksy
# Licence and copyright: see _community/README.md
meta:
  id: wolf_rpg_game_info
  title: WOLF RPG Editor game info
  license: MIT
  endian: le
seq:
  - id: magic
    contents: [0, 'W', 0, 0, 'O', 'L', 0, 'F', 'M', 0]
    
  - id: setting1_len
    type: u4
  - id: setting1
    type: u1
    repeat: expr
    repeat-expr: setting1_len
    
  - id: setting2_len
    type: u4
  - id: setting2
    type: len_str
    repeat: expr
    repeat-expr: setting2_len
    
  - id: filesize
    type: u4
    
  - id: keysize
    type: u4
  
  - id: setting3_len
    type: u4
  - id: setting3
    type: u2
    repeat: expr
    repeat-expr: setting3_len
  
  - id: keydata
    size: filesize - _io.pos
    doc: |
      encrypted_keydata
      
      ptr1 = readU4()
      ptr2 = readU4()
      arr1 = all_file_bytes[ptr1] as u2[keysize]
      arr2 = all_file_bytes[ptr2] as u2[keysize]
      key  = all_file_bytes[...sum(arr1, arr2) & 0xffff]
  
  - id: footer
    type: u1
    valid: 0xC2
types:
  len_str:
    seq:
      - id: len
        type: u4
      - id: str
        size: len
