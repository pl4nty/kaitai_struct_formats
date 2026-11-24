# Imported from https://github.com/CodeDragon82/nds-ware/blob/0e9e5a19e6fac3ce7444b4c0c460730c2ff61130/definitions/g2d.ksy
meta:
  id: nintendo_g2d
  title: Nintendo DS G2D graphics file
  license: MIT
  encoding: UTF-8
  endian: le

seq:
  - id: header
    type: header
  - id: blocks
    type: block
    repeat: expr
    repeat-expr: header.block_count
    
types:
  header:
    -webide-representation: '{magic}'
    seq:
      - id: magic
        size: 4
        type: str
      - id: byte_order
        type: u2
      - id: version
        type: u2
      - id: file_size
        type: u4
      - id: header_size
        type: u2
      - id: block_count
        type: u2

  block:
    -webide-representation: '{magic}'
    seq:
      - id: magic
        size: 4
        type: str
      - id: size
        type: u4
      - id: data
        type:
          switch-on: magic
          cases:
            '"TTLP"': pltt_block
            '"RAHC"': char_block
            
  #####################
  #### NCLR Blocks ####
  #####################
        
  pltt_block:
    seq:
      - id: colour_format
        type: u4
      - id: extended_palette
        type: u4
      - id: palette_data_size
        type: u4
      - id: palette_data_offset
        type: u4
    
    instances:
      palette_data:
        pos: _io.pos - 16 + palette_data_offset
        size: palette_data_size
        
  #####################
  #### NCGR Blocks ####
  #####################
  
  char_block:
    seq:
      - id: width
        type: u2
      - id: height
        type: u2
      - id: colour_format
        type: u4
      - id: mapping_mode
        type: u4
      - id: graphics_type
        type: u4
      - id: graphics_data_size
        type: u4
      - id: graphics_data_offset
        type: u4
      - id: graphics_data
        size: graphics_data_size
        type: graphics_data(4 << colour_format)
          
  graphics_data:
    params:
      - id: tile_size
        type: u4
    seq:
      - id: tiles
        size: tile_size
        repeat: eos
