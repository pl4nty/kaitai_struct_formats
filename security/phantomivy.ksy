# Imported from https://github.com/TeamT5/MalCfgParser/blob/d62d7c38c8e92251ef194aa4988cdc4824a811dd/kaitai_structs/phantomivy.ksy
meta:
  id: phantomivy
  title: PhantomIvy malware configuration
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: password
    size: 0x10
    type: str
    encoding: ASCII
  - id: unused
    size: 0x37
  - id: cnc_count
    type: u4
  - id: cnc
    type: cnc
    repeat: expr
    repeat-expr: cnc_count+1

instances:
  mutex:
    io: _root._io
    pos: 0x2b6
    size: 0x9
    type: str
    encoding: ASCII

types:
  cnc:
    seq:
      - id: len
        type: u1
      - id: host
        size: len
        type: str
        encoding: ASCII
      - id: type
        type: u1
      - id: port
        type: u2
      
