# Imported from https://github.com/TCP-23/GMF2-Tools/blob/ef980aa17bf5b223d45b1fa714b6dfff280fa6c9/addon_source/kaitai_defs/tme.ksy
meta:
  id: nmh_tme
  file-extension: TME, tme
  license: LicenseRef-All-Rights-Reserved
  encoding: Shift_JIS
  endian: le

seq:
  - id: unparsed_1
    size: 4
  
  - size: 4
  
  - id: unparsed_2
    size: 2
  
  - id: csm_flags
    type: u1
  
  - id: unparsed_3
    size: 53
  
  - id: img_width
    type: u4
  - id: img_height
    type: u4
  
  - id: unparsed_4
    size: 40
  
  - id: pixels_data
    size: pixel_size
    
  - id: unparsed_5
    size: 96
  
  - id: palette_data
    size: 1024
instances:
  pixel_size:
    value: img_width * img_height
