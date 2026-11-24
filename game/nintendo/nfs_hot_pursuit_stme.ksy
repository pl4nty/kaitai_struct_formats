# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/stme.ksy
meta:
  id: nfs_hot_pursuit_stme
  title: STME streaming package (NFS Hot Pursuit Wii)
  file-extension: stm
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: magic
    contents: STME
  - id: version
    size: 4
    doc: 01 01 01 0f.
  - id: platform
    contents: WI01
  - id: count
    type: u4
  - id: records
    type: record
    repeat: expr
    repeat-expr: count
types:
  record:
    seq:
      - id: kind
        type: u4
      - id: name
        size: 0x24
        type: strz
        encoding: ASCII
      - id: data_offset
        type: u4
      - id: size
        type: u4
      - id: header_size
        type: u4
      - id: rest
        size: 0x0c
    instances:
      data:
        io: _root._io
        pos: data_offset
        size: size
        if: size > 0
