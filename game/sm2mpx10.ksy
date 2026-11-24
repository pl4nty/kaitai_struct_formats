# Imported from https://github.com/mnakamura1337/engine_ikura/blob/17feacdcb2b20f47e155ad6df6b70cd9bc867550/sm2mpx10.ksy
meta:
  id: sm2mpx10
  title: Ikura GDL SM2MPX10 archive
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: header
  - id: index
    size: header.index_size - header.header_size
    type: index
types:
  header:
    seq:
      - id: magic
        contents: "SM2MPX10"
      - id: num_files
        type: u4
      - id: index_size
        type: u4
      - id: archive_name
        size: 12
        type: str
        encoding: Shift_JIS
      - id: header_size
        type: u4
  index:
    seq:
      - id: entries
        type: index_entry
        repeat: eos
  index_entry:
    seq:
      - id: filename
        size: 12
        type: str
        pad-right: 0
        encoding: Shift_JIS
      - id: offset
        type: u4
      - id: size
        type: u4
    instances:
      body:
        io: _root._io
        pos: offset
        size: size
