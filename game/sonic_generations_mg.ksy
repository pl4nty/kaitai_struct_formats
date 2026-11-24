# Imported from https://github.com/remixer-dec/GameTranslationPipelines/blob/b145e6972ee8ae8ed121c0ea64ffa49fbf71a189/3DS/Sonic%20Generations/TranslatorUI/MG.ksy
meta:
  id: sonic_generations_mg
  file-extension: MG
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents: [0x23,0x4d,0x53,0x47,0x00,0x01,0x03,0x00]
  - id: itemcount
    type: u4
  - id: unknown
    type: u4
  - id: ptr
    type: item_pointer
    repeat: expr
    repeat-expr: itemcount
    
types:
  item_pointer:
    seq:
      - id: empty
        type: u4
      - id: ptr_addr
        type: u4
      - id: var_addr
        type: u4
      - id: empty2
        type: u4
    instances:
      the_item:
        pos: ptr_addr
        type: item
  item:
    seq:
      - id: empty
        type: u4
      - id: ptr_ptr
        type: u4
    instances:
      str_ptr:
        pos: ptr_ptr
        type: u4
      str_str:
        pos: str_ptr
        size: _parent.var_addr - str_ptr
        type: str
        encoding: UTF-16LE
      var_name:
        pos: _parent.var_addr
        size: 16
        type: str
        encoding: ASCII
        
