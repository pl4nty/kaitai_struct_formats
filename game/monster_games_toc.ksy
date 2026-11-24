# Imported from https://github.com/TheGameCommunity/ExciteModder/blob/82eadbf9fafb5b699a5247fc4737e7eee22289fe/src/main/resources/kaitai/toc_monster.ksy
meta:
  id: monster_games_toc
  title: Monster Games Table of Contents
  file-extension: toc
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: header
  - id: details
    type: details
    repeat: expr
    repeat-expr: header.num_file
  - id: filenames
    type: filenames
    repeat: expr
    repeat-expr: header.num_file
types:
  header:
    seq:
      - id: magic_1
        size: 8
        contents: "0SERCOTE"
      - id: version_1
        type: u4
      - id: unknown_1
        type: u4
      - id: magic_2
        size: 4
        contents: "!IGM"
      - id: version_2
        type: u4
      - id: unknown_2
        type: u4
      - id: unix_time
        type: u4
        doc: Creation Date
      - id: num_file
        type: u4
      - id: uncompressed_res_size
        type: u4
        doc: Add 128
      - id: compressed_res_size
        type: u4
        doc: Add 128
      - id: unknown_3
        type: u4
        doc: Either 0 128 or 1152
      - id: filename_dir_len
        type: u4
  details:
    seq:
      - id: offset_filename
        type: u4
      - id: type_code
        size: 4
        type: str
        encoding: UTF-8
      - id: type_code_int
        type: u4
      - id: file_size
        type: u4
      - id: file_offset
        type: u4
        doc: Add 128
      - id: hash
        type: u4
      - id: unknown_1
        type: u1
        repeat: expr
        repeat-expr: 16
    instances:
      name:
        pos: ((_parent.header.num_file + 1) * 40) + 0xc + offset_filename
        type: str
        terminator: 0
        include: false
        encoding: UTF-8
  filenames:
    seq:
      - id: filename
        type: str
        terminator: 0
        encoding: UTF-8
