# Imported from https://github.com/rh-hideout/rhh-docs/blob/17e6d5ec2c7ecb8cd98447f0e8d81b3614e06ced/GC/Genius_Sonority/binary_templates/toc.ksy
meta:
  id: genius_sonority_toc
  file-extension: toc
  license: LicenseRef-All-Rights-Reserved
  endian: be

seq:
  - id: magic
    contents: 'GLLA'
  - id: version
    size: 4
  - id: entry_count
    type: u4
  - id: reserved
    type: u4
  - id: data_pos
    type: u4
  - id: header_size
    type: u4
  - id: unk4
    type: u4
  - id: unk5
    type: u4

instances:
  entry:
    pos: data_pos
    size: 16
    type: data
    repeat: expr
    repeat-expr: entry_count

types:
  data:
    seq:
      - id: index
        type: u4
      - id: name_pos
        type: u4
    instances:
      name:
        io: _root._io
        pos: name_pos
        type: strz
        encoding: ASCII
