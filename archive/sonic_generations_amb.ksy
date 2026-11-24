# Imported from https://github.com/remixer-dec/GameTranslationPipelines/blob/b145e6972ee8ae8ed121c0ea64ffa49fbf71a189/3DS/Sonic%20Generations/TranslatorUI/amb.ksy
meta:
  id: sonic_generations_amb
  title: Sonic Generations (3DS) AMB format
  file-extension: amb
  license: LicenseRef-All-Rights-Reserved
  endian: le
  
seq:
  - id: magic
    contents: [0x23,0x41,0x4d,0x42]
  - id: endian
    type: u4
  - id: unknown
    type: u8
  - id: file_count
    type: u4
  - id: start
    type: u4
  - id: data_start
    type: u4
  - id: name_start
    type: u4
  - id: files
    type: file_item(_index)
    repeat: expr
    repeat-expr: file_count
instances:
  file_offset:
    value: name_start - files[file_count-1].loc - files[file_count-1].length
types:
  file_item:
    params:
      - id: i
        type: u4
    seq:
      - id: loc
        type: u4
      - id: length
        type: u4
      - id: divider
        contents: [0xff,0xff,0xff,0xff,0x00,0x00,0x00,0x00]
    instances:
      file_content:
        pos: loc
        size: length
      file_name:
        pos: _parent.name_start + i * 32
        size: 32
        type: str
        encoding: ASCII
