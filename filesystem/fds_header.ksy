# Imported from https://github.com/taotao54321/fcdstools/blob/da9efc86b4f0856c2cec8b9a51957815334c7350/kaitai/fds_header.ksy
# Licence and copyright: see _community/README.md
meta:
  id: fds_header
  title: 'Famicom Disk System disk image - header'
  license: GPL-3.0-only
doc-ref: https://wiki.nesdev.com/w/index.php/Family_Computer_Disk_System

seq:
  - id: magic
    contents: [0x46, 0x44, 0x53, 0x1A]
  - id: side_count
    type: u1
  - id: reserved
    size-eos: true
