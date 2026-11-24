# Imported from https://github.com/taotao54321/fcdstools/blob/da9efc86b4f0856c2cec8b9a51957815334c7350/kaitai/fds_regular.ksy
# Licence and copyright: see _community/README.md
meta:
  id: fds_regular
  title: 'Famicom Disk System disk image - regular format'
  file-extension: fds
  license: GPL-3.0-only
  imports:
    - fds_header
    - fds_info_block
    - fds_file_header_block
doc-ref: https://wiki.nesdev.com/w/index.php/Family_Computer_Disk_System

seq:
  - id: header
    size: 16
    type: fds_header
  - id: sides
    size: 65500
    type: side
    repeat: expr
    repeat-expr: header.side_count
types:
  side:
    seq:
      - id: info_block_code
        contents: [1]
      - id: info
        type: fds_info_block
      - id: amount_block_code
        contents: [2]
      - id: amount
        type: u1
      - id: files
        type: file
        repeat: expr
        repeat-expr: amount
  file:
    seq:
      - id: file_header_block_code
        contents: [3]
      - id: header
        type: fds_file_header_block
      - id: file_data_block_code
        contents: [4]
      - id: data
        size: header.size
