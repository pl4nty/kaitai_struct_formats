# Imported from https://gist.githubusercontent.com/rfuzzo/678045cd2ddd6eff081085881a075e4e/raw/61b85ec881b0eea1fd0bf9f2be17469c9d8bacca/witcher%203%20shader.cache%20kaitai%20ksy
meta:
  id: witcher3_shader_cache
  file-extension: cache
  license: LicenseRef-All-Rights-Reserved
  endian: le
  
seq:
  - id: shaders
    type: shader_entry
    repeat: expr
    repeat-expr: footer.dataentry_count
  - id: materials
    type: table_entry
    repeat: expr
    repeat-expr: footer.tableentry_count

instances:
  footer:
    pos: _io.size - 48
    size: 48
    type: footer

types: 
  footer:
    seq:
      - id: dataentry_count
        type: u4
      - id: tableentry_count
        type: u4
      - id: unk2
        type: u8
      - id: table_offset
        type: u8
      - id: table_size
        type: u8
      - id: unk3
        type: u8
      - id: magic
        contents: 'RDHS'
      - id: version
        type: u4
  shader_entry:
    seq:
      - id: header
        type: section_header
      - id: compressed_data
        size: header.zsize
        #process: zlib
    types:
      section_header:
        seq: 
          - id: hash
            type: u8
          - id: compression
            type: u1
            if: _root.footer.version > 2
          - id: size
            type: u4
            if: _root.footer.version > 2
          - id: zsize
            type: u4
  table_entry:
    seq:
      - id: top
        type: u4
      - id: header1
        size: 4
      - id: header2
        size: 8
      - id: header3
        size: 8
      - id: name
        type: vlq_bit6_prefixed_string
      - id: top2
        type: u4
      - id: lower1
        size: 8
      - id: lower2
        size: 8
      - id: unk2
        size: 36
      - id: unk3
        type: u4unkarray
      - id: strings1
        type: u4stringarray
      - id: strings2
        type: u4stringarray
     
    types:
      vlq_bit6:
        seq:
          - id: groups
            type: group
            repeat: until
            repeat-until: not _.has_next
        instances:
          len:
            value: groups.size
          value:
            value: >-
              groups[0].value
              + (len >= 2 ? (groups[1].value << 6) : 0)
              + (len >= 3 ? (groups[2].value << 13) : 0)
              + (len >= 4 ? (groups[3].value << 20) : 0)
              + (len >= 5 ? (groups[4].value << 27) : 0)
              + (len >= 6 ? (groups[5].value << 34) : 0)
              + (len >= 7 ? (groups[6].value << 41) : 0)
              + (len >= 8 ? (groups[7].value << 48) : 0)
        types:
          group:
            seq:
              - id: b
                type: u1
            instances:
              has_next:
                value: (b & 0b0100_0000) != 0
              value:
                value: b & 0b0011_1111
      vlq_bit6_prefixed_string:
        seq:
          - id: len
            type: vlq_bit6
          - id: buf
            size: len.value
            type: str
            encoding: UTF-8
      u4stringarray:
        seq:
          - id: count
            type: u4
          - id: list
            type: stringlistentry
            repeat: expr
            repeat-expr: count
            if: count > 0
        types:
          stringlistentry:
            seq:
              - id: val
                type: vlq_bit6_prefixed_string
              - id: idx
                type: u1
      u4unkarray:
        seq:
          - id: count
            type: u4
          - id: list
            size: 32
            repeat: expr
            repeat-expr: count
            if: count > 0
            
  
