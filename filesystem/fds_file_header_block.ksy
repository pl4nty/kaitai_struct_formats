# Imported from https://github.com/taotao54321/fcdstools/blob/da9efc86b4f0856c2cec8b9a51957815334c7350/kaitai/fds_file_header_block.ksy
# Licence and copyright: see _community/README.md
meta:
  id: fds_file_header_block
  title: 'Famicom Disk System disk image - file header block'
  license: GPL-3.0-only
doc-ref: https://wiki.nesdev.com/w/index.php/Family_Computer_Disk_System

seq:
  - id: seq_num
    type: u1
  - id: id
    type: u1
  - id: name
    size: 8
  - id: addr
    type: u2le
  - id: size
    type: u2le
  - id: type
    type: u1
