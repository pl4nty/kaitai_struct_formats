# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/switch/rstb.ksy
meta:
  id: rstb
  title: Zelda BOTW/TOTK Resource Size Table (RSTB)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  BOTW/TOTK Resource Size Table, per lib-rstb.c. Flat crc32+name size
  lookup, no relocations -- the whole file length is known up front
  from the two header counts.
  Reference: zeldamods.org/wiki/ResourceSizeTable.product.rsizetable
seq:
  - id: magic
    contents: "RSTB"
  - id: crc_count
    type: u4
  - id: name_count
    type: u4
  - id: crc_entries
    type: crc_entry
    repeat: expr
    repeat-expr: crc_count
  - id: name_entries
    type: name_entry
    repeat: expr
    repeat-expr: name_count
types:
  crc_entry:
    seq:
      - id: crc32
        type: u4
      - id: size
        type: u4
  name_entry:
    seq:
      - id: name
        size: 128
        type: str
        terminator: 0
        encoding: ASCII
      - id: size
        type: u4
