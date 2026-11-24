# Imported from https://github.com/TeamT5/MalCfgParser/blob/d62d7c38c8e92251ef194aa4988cdc4824a811dd/kaitai_structs/waterbear.ksy
meta:
  id: waterbear
  title: Waterbear malware configuration
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: pattern
    size: 0x10
  - id: len
    type: u4
  - id: version
    size: 0x10
    type: str
    encoding: ASCII
  - id: mutex
    size: 0x10
    type: str
    encoding: ASCII
  - id: c2_server
    size: 0x78
  - id: port
    type: u2
    
  
