# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/rst.ksy
meta:
  id: rst
  title: Monster Games RST archive (Excite Truck / Excitebots, Wii)
  license: LicenseRef-All-Rights-Reserved
  endian:
    switch-on: _root.magic
    cases:
      '"RST0"': be
      '"0TSR"': le
doc: |
  Monster Games RST ("RST0"/"0TSR") archive, per lib-rst.c. Supports
  both endiannesses (selected by the magic itself) and an optional
  QuickLZ-compressed payload; this definition covers only the
  fixed 0x80-byte RST header and the old-style (Excite Truck) TOC
  record layout that sits directly after it when no separate .toc
  sidecar and no QuickLZ wrapper are present. The newer Excitebots'
  TOC (separate sidecar, string pool, relative offsets into a
  QuickLZ-decompressed payload) is not modeled here.
seq:
  - id: magic
    size: 4
    type: str
    encoding: ASCII
    valid:
      any-of: ['"RST0"', '"0TSR"']
  - id: unknown_04
    size: 0x18 - 4
  - id: data_offset
    type: u4
  - id: unknown_1c
    size: 4
  - id: num_files
    type: u4
  - id: unknown_24
    size: 0x80 - 0x24
instances:
  is_big_endian:
    value: magic == "RST0"
  records:
    pos: 0x80
    type: old_toc_record
    repeat: expr
    repeat-expr: num_files
types:
  old_toc_record:
    doc: 0x44 bytes; little-endian regardless of the container's own endianness.
    seq:
      - id: name
        size: 32
        type: str
        terminator: 0
        encoding: ASCII
      - id: unknown_20
        size: 0x28 - 0x20
      - id: file_size
        type: u4le
      - id: file_offset
        type: u4le
      - id: unknown_30
        size: 0x44 - 0x30
