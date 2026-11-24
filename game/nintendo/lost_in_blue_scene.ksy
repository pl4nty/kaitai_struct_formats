# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/lib_wii_scene.ksy
meta:
  id: lost_in_blue_scene
  title: Lost in Blue Shipwrecked WII scene archive (.bin)
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  `WII\0` scene archive (Lost in Blue: Shipwrecked, Wii). With `variant` 2 the
  `{offset, size}` pairs are followed by 0x10-byte NUL-padded member names
  (`0000Model.bin`, `0000Snd.bin`, ...); member data follows 0x20 aligned. With
  `variant` 0 (animal, Stage, Effect, Text, ...) there is no name table and
  empty members are skipped.
seq:
  - id: magic
    contents: ['WII', 0]
  - id: version_float
    type: f4
    doc: 1.0.
  - id: num_entries
    type: u4
    doc: 2 or 3 in the named variant.
  - id: variant
    type: u4
    doc: 2 = named members, 0 = unnamed.
  - id: pairs
    type: pair
    repeat: expr
    repeat-expr: num_entries
  - id: names
    size: 0x10
    type: strz
    encoding: ASCII
    repeat: expr
    repeat-expr: num_entries
    if: variant != 0
types:
  pair:
    seq:
      - id: offset
        type: u4
      - id: len_data
        type: u4
