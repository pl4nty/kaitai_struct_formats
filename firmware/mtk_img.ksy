# Imported from https://github.com/nccgroup/mtk_bp/blob/f1d08ae18c10410637b0a97398501f236919e6c1/mtk_structs/mtk_img.ksy
meta:
  id: mtk_img
  file-extension: mtk_img
  license: GPL-3.0-only
  encoding: ASCII
  endian: le

# u-boot/u-boot/blob/master/tools/mtk_image.c
# u-boot/u-boot/blob/master/tools/mtk_image.h

seq:
  - id: file_info
    type: gfh_common_header

  - id: hdrs
    size: file_info.body.as<gfh_file_info>.hdr_size - file_info.size
    type: header_entries

  - id: code
    size-eos: true
    #size: file_info.body.as<gfh_file_info>.total_size

enums:
  gfh_type:
    0: gfh_type_file_info
    1: gfh_type_bl_info
    7: gfh_type_brom_cfg
    3: gfh_type_bl_sec_key
    2: gfh_type_anti_clone
    8: gfh_type_brom_sec_cfg
    0x200: gfh_type_0x200
    0x202: gfh_type_rsa_maybe

    
types:
  gfh_common_header:
    seq:
      - id: magic
        # GFH_HEADER_MAGIC
        contents: "MMM"
    
      - id: version
        type: u1
    
      - id: size
        type: u2
        
      - id: type
        type: u2
        enum: gfh_type
        
      - id: body
        size: size - 8
        type:
          switch-on: type
          cases:
            'gfh_type::gfh_type_file_info': gfh_file_info
            'gfh_type::gfh_type_0x200': gfh_0x200
            'gfh_type::gfh_type_rsa_maybe': gfh_rsa_maybe

  gfh_file_info:
    seq:
      - id: name
        size: 12
        type: strz
        encoding: ASCII
        
      - id: unused
        type: u4
        
      - id: file_type
        type: u2
        
      - id: flash_type
        type: u1
        
      - id: sig_type
        type: u1
        
      - id: load_addr
        type: u4
        
      - id: total_size
        type: u4
      - id: max_size
        type: u4
      - id: hdr_size
        type: u4
      - id: sig_size
        type: u4
      - id: jump_offset
        type: u4
      - id: processed
        type: u4

  gfh_0x200:
    seq:
      - id: filename_maybe
        size: 0x80
        type: strz
      - id: version_maybe
        type: strz

  gfh_rsa_maybe:
    seq:
      - id: bleh1
        type: u4be
      - id: bleh2
        type: u4be
      - id: bleh3
        type: u4be
      - id: bleh4
        type: u4be


  header_entries:
    seq:
      - id: entries
        type: gfh_common_header
        repeat: eos
