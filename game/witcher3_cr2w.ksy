# Imported from https://gist.githubusercontent.com/rfuzzo/6e7a0669a7f8140d28a281b16bb3cb0f/raw/4775f64f5bd92ae5b75087a53d563ddaae8db5ff/witcher3_cr2w.ksy
meta:
  id: witcher3_cr2w
  title: REDengine CR2W resource file
  license: LicenseRef-All-Rights-Reserved
  endian: le
  
seq:
  - id: header
    type: cr2w_header



  - id: exports
    type: cr2w_export_data(_index)
    repeat: expr
    repeat-expr: header.tables[4].itemcount   
    if: header.tables[4].itemcount != 0
  - id: buffers
    type: cr2w_buffer_data(_index)
    repeat: expr
    repeat-expr: header.tables[5].itemcount   
    if: (header.tables[5].itemcount != 0) and (header.fileheader.buffersize > header.fileheader.size)
  - id: embedded
    type: cr2w_embedded_data(_index)
    repeat: expr
    repeat-expr: header.tables[6].itemcount   
    if: header.tables[6].itemcount != 0

types:
  cr2w_export_data:
    params:
      - id: idx
        type: u4
    instances:
      body:
        pos: _parent.header.exports[idx].dataoffset
        size: _parent.header.exports[idx].datasize
        #type: cr2w_export_data_body
  cr2w_export_data_body:
    seq:
      - id: vars
        type: cr2w_var
        repeat: until
        repeat-until: _.typename == 0
  cr2w_var:
    seq:
      - id: typename
        type: u2
      - id: varname
        type: u2
        if: typename != 0
      - id: varsize
        type: u4
        if: typename != 0
      - id: vardata
        size: varsize
        if: typename != 0   
  cr2w_buffer_data:
    params:
      - id: idx
        type: u4
    instances:
      body:
        pos: _parent.header.buffers[idx].offset
        size: _parent.header.buffers[idx].memsize
  cr2w_embedded_data:
    params:
      - id: idx
        type: u4
    instances:
      body:
        pos: _parent.header.embedded[idx].dataoffset
        size: _parent.header.embedded[idx].datasize
  cr2w_header:
    seq:
      - id: magic
        contents: [0x43, 0x52, 0x32, 0x57]
      - id: fileheader
        type: cr2w_fileheader
      - id: tables
        type: cr2w_table
        repeat: expr
        repeat-expr: 10
      - id: stringtable
        size: tables[0].itemcount
        type: cr2w_stringtable
    instances:
      names:
        pos: tables[1].offset
        type: cr2w_name
        repeat: expr
        repeat-expr: tables[1].itemcount
        if: tables[1].offset > 0
      imports:
        pos: tables[2].offset
        type: cr2w_import
        repeat: expr
        repeat-expr: tables[2].itemcount
        if: tables[2].offset > 0
      properties:
        pos: tables[3].offset
        type: cr2w_property
        repeat: expr
        repeat-expr: tables[3].itemcount
        if: tables[3].offset > 0
      exports:
        pos: tables[4].offset
        type: cr2w_export
        repeat: expr
        repeat-expr: tables[4].itemcount
        if: tables[4].offset > 0
      buffers:
        pos: tables[5].offset
        type: cr2w_buffer
        repeat: expr
        repeat-expr: tables[5].itemcount
        if: tables[5].offset > 0
      embedded:
        pos: tables[6].offset
        type: cr2w_embedded
        repeat: expr
        repeat-expr: tables[6].itemcount
        if: tables[6].offset > 0
    types:
      cr2w_fileheader:
        seq:
          - id: version
            type: u4
          - id: flags
            type: u4
          - id: timestamp
            type: u8
          - id: version2
            type: u4
          - id: size
            type: u4
          - id: buffersize
            type: u4
          - id: crc
            type: u4
          - id: numchunks
            type: u4
      cr2w_table:
        seq:
          - id: offset
            type: u4
          - id: itemcount
            type: u4
          - id: crc
            type: u4
      cr2w_stringtable:
        seq:
          - id: name
            type: strz
            encoding: UTF-8
            repeat: eos
      cr2w_name:     
        seq:
          - id: value
            type: u4
          - id: hash
            type: u4
      cr2w_import:     
        seq:
          - id: depotpath
            type: u4
          - id: classname
            type: u2
          - id: flags
            type: u2
      cr2w_property:     
        seq:
          - id: classname
            type: u2
          - id: classflags
            type: u2
          - id: propertyname
            type: u2
          - id: propertyflags
            type: u2
          - id: hash
            type: u8
      cr2w_export:     
        seq:
          - id: classname
            type: u2
          - id: objectflags
            type: u2
          - id: parentid
            type: u4
          - id: datasize
            type: u4
          - id: dataoffset
            type: u4
          - id: template
            type: u4
          - id: crc
            type: u4
      cr2w_buffer:     
        seq:
          - id: flags
            type: u4
          - id: index
            type: u4
          - id: offset
            type: u4
          - id: disksize
            type: u4
          - id: memsize
            type: u4
          - id: crc
            type: u4
      cr2w_embedded:     
        seq:
          - id: importindex
            type: u4
          - id: path
            type: u4
          - id: pathhash
            type: u8
          - id: dataoffset
            type: u4
          - id: datasize
            type: u4       
        
