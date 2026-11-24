# Imported from https://github.com/Wargus/stargus/blob/b6b90dceb7d327909987580d680b8241bedd568b/src/kaitai/flingy_dat.ksy
# Licence and copyright: see _community/README.md
meta:
  id: starcraft_flingy_dat
  title: StarCraft flingy.dat
  license: GPL-2.0-only
  endian: le
  bit-endian: le

seq:
  - id: sprite
    type: u2
    repeat: expr
    repeat-expr: num_lines
    doc: |
      The sprites.dat entry corresponding to the flingy.dat entry. [pointer to
      sprites.dat]

  - id: speed
    type: u4
    repeat: expr
    repeat-expr: num_lines
    doc: |
      Maximum speed at which the sprite will move. Measured in pixels-per-frame, but
      written as "Speed*(320/3)" (rounded up, it's weird, but that's how it works).
      Works ONLY if "Move Control" is set to "Flingy.dat Control".

  - id: acceleration
    type: u2
    repeat: expr
    repeat-expr: num_lines
    doc: |
      How fast the sprite speeds up or slows down. Added to or subtracted from current
      speed until it reaches the Top Speed or 0. Measured in pixels-per-frame.  Works
      ONLY if "Move Control" is set to "Flingy.dat Control".

  - id: halt_distance
    type: u4
    repeat: expr
    repeat-expr: num_lines
    doc: |
      Distance from its destination at which the sprite will begin to deccelerate from
      its Top Speed to a complete halt. Measured in pixels*256.

  - id: turn_radius
    type: u1
    repeat: expr
    repeat-expr: num_lines
    doc: |
      The distance the sprite requires to "wipe around" to turn to another direction.
      Works ONLY if "Move Control" is set to "Flingy.dat Control".

  - id: unused
    type: u1
    repeat: expr
    repeat-expr: num_lines
    doc: Unused.

  - id: movement_control
    type: u1
    repeat: expr
    repeat-expr: num_lines
    doc: |
      Indicates the mechanism that is used to control the movement of the flingy.dat
      entry. "Flingy.dat Control" makes use of the Acceleration, Speed, Turn Style and
      Turn Radius properties, i.e. the values in this editor will be used.
      "Iscript.bin Control" ignores these properties and follows only the Iscript
      opcode sequence. "Partially Mobile/Weapon" is used for various weapons sprites,
      not completely understood.

instances:
  num_lines:
    value: file_size / record_size
    doc: |
      A division of file size though the record size gives the number of records in
      the file to parse.

  record_size:
    value: 15
    doc: The size of one data record. This is all type sizes in the format summarized.

  file_size:
    value: '_io.size'
