# Imported from https://github.com/jamchamb/gamecube-formats/blob/d8517dcf2d4c4eb27e0b0ec9224277c201b2020e/gci.ksy
meta:
  id: gamecube_gci
  title: GameCube GCI save file
  file-extension: gci
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: header
    type: header
  - id: data
    size-eos: true
types:
  header:
    seq:
      - id: gameid
        size: 3
      - id: region
        size: 1
      - id: company
        size: 2
      - id: unnused
        type: u1
      - id: bi_flags
        type: u1
      - id: file_name
        size: 32
      - id: last_modified
        type: u4
      - id: graphic_offset
        type: u4
      - id: icon_format
        type: u2
      - id: anim_speed
        type: u2
      - id: permissions
        type: u1
      - id: copy_counter
        type: u1
      - id: first_block
        type: u2
      - id: block_count
        type: u2
      - id: unused2
        type: u2
      - id: comments_offset
        type: u4
  data:
    instances:
      game_name:
        pos: _root.header.comments_offset
        size: 32
      file_info:
        pos: _root.header.comments_offset + 32
        size: 32
