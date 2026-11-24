# Imported from https://github.com/djey47/tduf-next/blob/707ff9f7742067e989cb231e66e6524c6475fbbe/doc/RE/2db/2db.ksy
meta:
  id: tdu_2db
  file-extension: 2db
  license: MIT
  endian: le
  
seq:
  - id: file_hdr
    type: file_header
  - id: image_data
    size: file_hdr.other_size1 - 64
  - id: file_ftr
    type: file_footer
types:
  file_header:
    seq:
      - id: file_version
        type: u2
      - id: zero1
        type: u2
      - id: zero2
        type: u4
      - id: file_size
        type: u4
      - id: tag
        size: 8
        type: str
        encoding: ASCII
      - id: zero3
        type: u4
      - id: other_size1
        type: u4          
      - id: other_size2
        type: u4
      - id: name
        size: 8
        type: strz
        encoding: ASCII
      - id: width
        type: u2
      - id: height
        type: u2
      - id: one
        type: u2
      - id: mipmaps_count1
        type: u1
      - id: mipmaps_count2
        type: u1
      - id: image_format
        type: u1
        enum: format
      - id: zero4
        type: u1 
      - id: zeroes
        size: 10
      - id: image_type
        type: u4
        enum: type
      - id: flags
        type: u4
      - id: unknown1
        type: u4
      - id: unknown2
        type: u4      
      - id: zero5
        type: u4
  file_footer:
    seq:
      - id: real
        size: 8
        type: strz
        encoding: ASCII
      - id: unknown1
        type: u4
      - id: unknown2
        type: u4            
enums:
  format:
    0x84: dxt1
    0x88: dxt5
    0x90: argb8
    0xc4: dxt1_variant
  type:
    0x1d: raw_bmp
    0x33: dds_dxt1
    0x37: dds_dxt5
    
