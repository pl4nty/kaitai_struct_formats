# Imported from https://github.com/rustyoz/catlogparser/blob/ec35012911a5fc4213cc5aface1eb1896e2f2447/log.ksy
meta:
  id: catlog
  file-extension: log
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: be
  
seq:
  - id: version
    type: u2
  - id: type
    type: strz
  - id: dictid
    type: u2
  - id: framelength
    type: u2
  - id: framdelimiter
    type: u8
  - id: configfile
    type: strz
  - id: system
    type: strz
  - id: entry
    type: entry
    repeat: eos


    
types:
  entry:
    seq:
      - id: unixmilli
        type: u8
      - id: fill4byte
        type: u4
      - id: ipaddress
        type: u4
      - id: fill4byte2
        type: u4
      - id: counter
        type: u1
      - id: pushinterval
        type: u2
      - id: count64
        type: u2
      - id: points64
        type: point64
        repeat: expr
        repeat-expr: count64
      - id: count32
        type: u2
      - id: points32
        type: point32
        repeat: expr
        repeat-expr: count32
      - id: count16
        type: u2
      - id: points16
        type: point16
        repeat: expr
        repeat-expr: count16
      - id: count8
        type: u2
      - id: points8
        type: point8
        repeat: expr
        repeat-expr: count8
      - id: framedelimiter
        type: u8

  point8:
    seq:
      - id: pointindex
        type: u2
      - id: value
        type: u1
        
  point16:
    seq:
      - id: pointindex
        type: u2
      - id: value
        type: u2
  
  point32:
    seq:
      - id: pointindex
        type: u2
      - id: value
        type: u4
        
  point64:
    seq:
      - id: pointindex
        type: u2
      - id: value
        type: u8
      
      
      
        
        
