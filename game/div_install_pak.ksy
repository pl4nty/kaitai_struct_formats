# Imported from https://github.com/vii1/DIV/blob/3692483012cbdf9c85b2f93f2ae6a35ac4dd193e/formats/install_pak.ksy
meta:
  id: div_install_pak
  title: DIV Games Studio installer package
  license: GPL-3.0-only
  encoding: ASCII
  endian: le

seq:
  - id: magic
    contents: ['stp',0x1a,0x0d,0x0a,0]
  - id: not_final_vol
    type: u1
  - id: num_files
    type: u4
  - id: files
    type: file_desc
    repeat: expr
    repeat-expr: num_files
    
types:
  file_desc:
    seq:
      - id: name
        size: 16
        type: strz
      - id: offset
        type: u4
      - id: z_size
        type: u4
      - id: u_size
        type: u4
        
    instances:
      file:
        pos: offset + 8
        size: z_size
        type:
          switch-on: z_size < u_size
          cases:
            true: compressed_file(z_size)
            false: raw_file(z_size)
            
  compressed_file:
    params:
      - id: size
        type: u4
    seq:
      - id: contents
        size: size
        process: zlib
        
  raw_file:
    params:
      - id: size
        type: u4
    seq:
      - id: contents
        size: size
