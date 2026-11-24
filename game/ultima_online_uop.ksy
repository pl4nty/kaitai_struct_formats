# Imported from https://github.com/polserver/polserver/blob/58c945271d5187fd2981c81f55987d39b1cb9e9a/pol-core/plib/uopreader/uopfile.ksy
meta:
  id: ultima_online_uop
  title: Ultima Online UOP archive
  file-extension: uop
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: header
  
types:
  header:
    seq:
      - id: magic
        contents: ["MYP",0]
      - id: version
        size: 4
      - id: signature
        size: 4
      - id: firstblock
        type: block_addr
      - id: maxfiles_per_block
        type: u4
      - id: nfiles
        type: u4
  
  block_body:
    seq:
      - id: nfiles
        type: u4
      - id: next_addr
        type: block_addr
      - id: files
        type: file
        repeat: expr
        repeat-expr: nfiles
        
  block_addr:
    seq: 
      - id: blockaddr
        type: u8
    instances:
      block_body:
        pos: blockaddr
        type: block_body
        if: blockaddr > 0
  

  data_header_v5:
    seq:
      - id: bytes
        size: _parent.file_len
      - id: filebytes
        size: _parent.compressed_size
      
  file:
    seq:
      - id: dataaddr
        type: u8
      - id: file_len
        type: u4
      - id: compressed_size
        type: u4
      - id: decompressed_size
        type: u4
      - id: filehash
        type: u8
      - id: adler32
        type: u4
      - id: compression_type
        type: u2
        enum: compression_type
    instances:
      data:
        pos: dataaddr
        size: file_len+compressed_size
        type: data_header_v5
        if: dataaddr > 0
        
enums:
  compression_type:
    0: no_compression
    1: zlib
  
