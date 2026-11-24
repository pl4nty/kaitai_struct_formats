# Imported from https://github.com/rustyoz/catlogparser/blob/ec35012911a5fc4213cc5aface1eb1896e2f2447/dict.ksy
meta:
  id: catlog_dict
  title: catlog dictionary
  file-extension: dict
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: be
  
seq:
  - id: header
    type: header
  - id: bitmapcount
    type: u2
  - id: bitmaps
    type: bitmap
    repeat: expr
    repeat-expr: bitmapcount
  - id: enumcount
    type: u2
  - id: enums
    type: enum
    repeat: expr
    repeat-expr: enumcount
  - id: pointcount
    type: u2
  - id: points
    type: point
    repeat: expr
    repeat-expr: pointcount
  

types:
  header:
    seq: 
      - id: version
        type: u2
      - id: magic
        type: strz
      - id: dictid
        type: u2
      - id: number0
        type: u2
      - id: number1
        type: u2
      - id: number2
        type: u2
      - id: number3
        type: u2
      - id: system
        type: strz
      - id: number4
        type: u2
      - id: number5
        type: u2
  
  
  bitmap:
    seq: 
      - id: name
        type: strz
      - id: count
        type: u2
      - id: values
        type: bitmapvalue
        repeat: expr
        repeat-expr: count
  
  bitmapvalue:
    seq: 
      - id: name
        type: strz
      - id: value
        type: u8
        
  enum:
    seq: 
      - id: name
        type: strz
      - id: count
        type: u2
      - id: values
        type: enumvalue
        repeat: expr
        repeat-expr: count
  
  enumvalue:
    seq: 
      - id: name
        type: strz
      - id: value
        type: u8
      
  point:
    seq:
      - id: name
        type: strz
      - id: category
        type: strz
      - id: description
        type: strz
      - id: units
        type: strz
      - id: index
        type: u2
      - id: type
        type: u1
      - id: properties
        type: u4
      - id: p1
        type: u4
      - id: p2
        type: u2
      - id: p3
        type: u4
      - id: p4
        type: u4
      - id: p5
        type: u4
      - id: p6
        type: u4
      - id: p7
        type: u4
      
      
      
        
        
