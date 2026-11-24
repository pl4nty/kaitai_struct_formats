# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/mde1.ksy
meta:
  id: little_kings_story_mde1
  title: Little King's Story event table (MDE1)
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Ousama Monogatari / Little King's Story (Wii) event tables
  (`event/boot/MissionStartEventDB.bin`). 16-byte records of eight u16 values
  (0xFFFF = unused); the field meanings are not documented.
seq:
  - id: magic
    contents: MDE1
  - id: zero
    size: 12
  - id: records
    type: record
    repeat: eos
types:
  record:
    seq:
      - id: fields
        type: u2
        repeat: expr
        repeat-expr: 8
