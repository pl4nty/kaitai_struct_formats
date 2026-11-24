# Imported from https://github.com/remixer-dec/GameTranslationPipelines/blob/b145e6972ee8ae8ed121c0ea64ffa49fbf71a189/3DS/Metal%20Gear%20Solid%20Snake%20Eater%203D/TranslatorUI/dat.ksy
meta:
  id: mgs3d_dat
  title: METAL GEAR Solid 3D Snake Eater
  file-extension: dat
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: sections
    type: sections
    repeat: expr
    repeat-expr: section_count
instances:
  section_count:
    pos: 0x1E
    type: u2
types:
  zeros:
    seq: 
      - id: zeroline
        contents: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        if: not is_final
    instances:
      final_bytes:
        pos: _io.pos
        type: u4
      is_final:
        value: final_bytes != 0
    
    
  localized_item:
    seq:
      - id: idk7
        type: u4
      - id: idk8
        type: u4
      - id: idk9
        type: u4
      - id: item_size
        type: u2
      - id: language_code
        type: u2
      - id: text
        size: item_size - 16
        type: strz
        encoding: UTF-8
  localized_items:
    seq:
      - id: items
        type: localized_item
        repeat: eos
  item_group:
    seq:
      - id: group_size
        type: u4
      - id: group
        size: group_size
        type: localized_items
      - id: padding
        type: u1
        repeat: eos
  item_group_wrap:
    seq:
      - id: idk4
        type: u4
      - id: inner_size
        type: u4
      - id: idk5
        type: u4
      - id: idk6
        type: u4
      - id: group
        size: inner_size - 16
        type: item_group
    instances:
      final_bytes:
        pos: _io.pos
        type: u8
      is_final:
        value: final_bytes == 0x10000000f0
    
  section:
    seq:
      - id: s1
        contents: [16,0,0,0,16,0,0,0,0,0,0,0]
      - id: idk
        type: u4
      - id: s2
        contents: [16,0,0,0,16,0,0,0,0,0,0,0]
      - id: idk_bin_1
        type: u2
      - id: idk_bin_2
        type: u2
      - id: s3
        size: 12
        if: is_real_section
      - id: idk3
        type: u4
        if: is_real_section
      - id: content
        type: item_group_wrap
        repeat: until
        repeat-until: _.is_final
        if: is_real_section
    instances:
      check:
        pos: _parent._io.pos
        type: u4
      is_real_section:
        value: check == 16
          
  sections:
    seq:
      - id: section
        type: section
      - id: footer
        type: footer
      - id: padding
        type: zeros
        repeat: until
        repeat-until: _.is_final or _io.eof
      
  footer:
    seq:
      - id: fixed
        contents: [240, 0, 0, 0, 16, 0, 0, 0]
      - id: unknown
        size: 4
      - id: zero
        contents: [0, 0, 0, 0]
