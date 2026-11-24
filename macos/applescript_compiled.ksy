# Imported from https://gist.githubusercontent.com/Jinmo/1571190ec9e801dfe2fc05713b606144/raw/50e8ef86f4f6ab2222be16a721a59fd416f61e9d/apple-script.yaml
meta:
  id: applescript_compiled
  title: Compiled AppleScript (.scpt)
  application: AppleScript files
  file-extension: scpt
  license: LicenseRef-All-Rights-Reserved
  endian: be

seq:
  - id: magic
    size: 4
    contents: "Fasd"
  - id: uas_magic
    size: 4
    contents: "UAS "
  - id: version
    type: u1
    repeat: expr
    repeat-expr: 4
  - id: subversion
    type: u1
    repeat: expr
    repeat-expr: 4
    if: version[0] >= 0x31 and version[1] >= 0x2e and version[2] >= 0x31 and version[3] >= 0x30

  - id: root
    type: fas_object

types:
  fas_object:
    seq:
      - id: header
        size: 5
        type: fas_header
        process: register_object(_root, _parent)
      - id: body
        type:
          switch-on: header.type
          cases:
            1: symbol
            2: list
            3: u2_inlined
            4: value_block
            6: record
            7: s4
            8: f8
            9: u1
            10: code_identifier
            11: user_identifier
            12: string
            13: command_block
            14: value_block
            15: data_block
            16: untyped_pointer_block
            17: untyped_data_block
            19: untyped_long_data_block

  u2_inlined:
    instances:
      value:
        value: _parent.header.inlined

  symbol:
    seq:
      - id: num
        type: u8
        if: _parent.header.inlined != 0

  record:
    seq:
      - id: a_id
        type: ref
        if: _parent.header.inlined == 3

      - id: b_id
        type: ref
        if: _parent.header.inlined == 3

      - id: next_id
        type: ref
        if: _parent.header.inlined == 3

      - id: a
        type: fas_object
        if: _parent.header.inlined == 3 and not a_id.exists.as<bool>

      - id: b
        type: fas_object
        if: _parent.header.inlined == 3 and not b_id.exists.as<bool>

      - id: next
        type: fas_object
        if: _parent.header.inlined == 3 and not b_id.exists.as<bool>

  fas_header:
    seq:
      - id: type
        type: u1
      
      - id: ref
        type: s2
      
      - id: inlined
        type: u2
  
  value_block:
    seq:
      - id: c
        type: u1

      - id: ref
        type: ref
        repeat: expr
        repeat-expr: _parent.header.inlined

      - id: ref_counter
        size: 0
        process: count_new(ref)

      - id: body
        type: fas_object
        repeat: expr
        repeat-expr: ref_counter.as<u2>
        if: _parent.header.inlined != 0 or c != 15

  data_block:
    seq:
      - id: t
        type: u1
      
      - id: desc
        size: _parent.header.inlined
        type: descriptor
        if: t == 8

      - id: content
        size: _parent.header.inlined
        if: t != 8
  
  descriptor:
    seq:
      - id: a
        type: u8
      
      - id: b
        type: u4
      
      - id: c
        size: 70
      
      - id: d
        type: u4
      
      - id: e
        type: u4
      
      - id: type
        type: u4
      
      - id: content
        size: _parent._parent.header.inlined - 94
  
  untyped_pointer_block:
    seq:
      - id: ref
        type: ref
        repeat: expr
        repeat-expr: _parent.header.inlined
  
      - id: ref_counter
        size: 0
        process: count_new(ref)

      - id: body
        type: fas_object
        repeat: expr
        repeat-expr: ref_counter.as<u2>
  
  code_identifier:
    seq:
      - id: c
        type: u1

      - id: body
        type:
          switch-on: c
          cases:
            0x0b: u8
            # class identifiers
            0x0a: u4
            0x2f: u4
            0x2e: resource_identifier
  
  resource_identifier:
    seq:
      - id: identifier
        type: u4
        repeat: expr
        repeat-expr: 6
  
  user_identifier:
    seq:
      - id: c
        type: u1
        doc: should be 0x30

      - id: a_len
        type: u2
      
      - id: a
        size: a_len
      
      - id: b_len
        type: u2
      
      - id: b
        size: b_len
  
  untyped_data_block:
    seq:
      - id: content
        size: _parent.header.inlined

  untyped_long_data_block:
    seq:
      - id: length
        type: u4

      - id: content
        size: length

  list:
    seq:
      - id: value_id
        type: ref
        if: _parent.header.inlined == 2

      - id: next_id
        type: ref
        if: _parent.header.inlined == 2

      - id: value
        type: fas_object
        if: _parent.header.inlined == 2 and not value_id.exists.as<bool>

      - id: next
        type: fas_object
        if: _parent.header.inlined == 2 and not next_id.exists.as<bool>

  command_block:
    seq:
      - id: type_id
        type: u1

      - id: subtype_id
        type: u2

      - id: bytecode_start
        type: u2

      - id: bytecode_end
        type: u2

      - id: ref
        type: ref
        repeat: expr
        repeat-expr: _parent.header.inlined

      - id: ref_counter
        size: 0
        process: count_new(ref)

      - id: body
        type: fas_object
        repeat: expr
        repeat-expr: ref_counter.as<u2>

  string:
    seq:
      - id: content_size
        type: u2

      - id: content
        size: content_size

      - id: style_size
        type: u2

      - id: style
        size: style_size

  ref:
    seq:
      - id: id
        type: s2

      # boolean type
      - id: exists
        size: 0
        process: ref_exists(_root, id)
