# Imported from https://gist.githubusercontent.com/edo9300/29527a6dac8c7b39ddfe637fefbe679b/raw/5203222dd45e55758726b2f1a26c69f68c1460f5/usrcheat.dat.ksy
meta:
  id: nds_usrcheat
  title: usrcheat.dat
  file-extension: dat
  license: LicenseRef-All-Rights-Reserved
  endian: le
  bit-endian: le
seq:
  - contents: 'R4 CheatCode'
  - type: u4
  - id: comment
    size: 0xF0
    type: str
    encoding: UTF-8
  - id: cheats
    type: cheat_entry_header(_index)
    repeat: until
    repeat-until: _.file_offset == 0
types:
  cheat_entry_header:
    params:
      - id: i
        type: u4
    seq:
      - id: game_code
        type: u4
      - id: crc_32
        type: u4
      - id: file_offset
        type: u8
    instances:
      file_offset_end:
        value: '_parent.cheats[i + 1].file_offset != 0 ? _parent.cheats[i + 1].file_offset : _root._io.size'
        if: file_offset > 0
      cheat_codes:
        io: _root._io
        pos: file_offset
        size: file_offset_end - file_offset
        type: cheat_data
        if: file_offset > 0

  cheat_data:
    seq:
      - id: game_name
        type: strz
        encoding: UTF-8
      - size: '(4 - (_io.pos & 3)) & 3'
      - id: cheat_count
        type: b28
      - id: active_flag
        type: b4
      - id: master_codes
        size: 4*8
      - id: cheat_array
        type: cheat_item
        repeat: eos
    instances:
      is_active:
        value: 'active_flag != 0'

  cheat_item:
    seq:
      - id: cheat_length
        type: b24
      - id: cheat_flags
        type: b4
      - id: cheat_type
        type: b4
      - id: name
        type: strz
        encoding: UTF-8
      - id: description
        type: strz
        encoding: UTF-8
      - id: padding
        size: '(4 - (_io.pos & 3)) & 3'
      - id: data
        type: cheat_item_data
    instances:
      is_folder:
        value: 'cheat_type & 1 == 1'
      mutually_exclusive:
        value: 'cheat_flags & 1 == 1'
      data_size:
        value: 'name.length + description.length + padding.length + 2'
      cheat_data:
        value: data.cheat_data
        if: 'is_folder == false'
      cheat_active:
        value: 'cheat_flags & 1 == 1'
      children:
        value: data.children
        if: is_folder

  cheat_item_data:
    seq:
      - id: num_cheat_data
        type: u4
        if: '_parent.cheat_type & 1 == 0'
      - id: cheat_data
        type: u4
        repeat: expr
        repeat-expr: num_cheat_data
        if: '_parent.cheat_type & 1 == 0'
      - id: children
        type: cheat_item
        repeat: expr
        repeat-expr: _parent.cheat_length
        if: '_parent.cheat_type & 1 != 0'
