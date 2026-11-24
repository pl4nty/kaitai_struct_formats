# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/gfmc.ksy
meta:
  id: kirby_gfmc
  title: Kirby's Return to Dream Land GFMC message file
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  "GFMC" message file of the Teolsil / HAL Kirby game (Kirby's Return to Dream
  Land, `message/<lang>/*.bin`). A 0x1c-byte header gives four section
  offsets:

  * `sec1` (= 0x1c) -- unused by the extractor.
  * `sec2` -- `{u4 label_hash, u4 count, u4 sec3_offset}` records.
  * `sec3` -- `u4` offsets into the string pool.
  * `sec4` -- the string pool.
seq:
  - id: magic
    contents: 'GFMC'
  - id: version
    type: u4
    doc: 0x10000.
  - id: file_size
    type: u4
  - id: sec1_offset
    type: u4
  - id: sec2_offset
    type: u4
  - id: sec3_offset
    type: u4
  - id: sec4_offset
    type: u4
instances:
  labels:
    pos: sec2_offset
    type: label
    repeat: expr
    repeat-expr: (sec3_offset - sec2_offset) / 12
  string_offsets:
    pos: sec3_offset
    type: u4
    repeat: expr
    repeat-expr: (sec4_offset - sec3_offset) / 4
types:
  label:
    seq:
      - id: label_hash
        type: u4
      - id: count
        type: u4
      - id: sec3_index_offset
        type: u4
        doc: Byte offset into `sec3` of the first string offset for this label.
  slot:
    doc: |
      One string slot. Address it with `pos: _root.sec4_offset + string_offsets[i]`.
    seq:
      - id: control_words
        type: control_word
        repeat: until
        repeat-until: _.value == 0x5458 and _.following == 0
      - id: terminator
        type: u2
        doc: The 0 that follows `0x5458`.
      - id: length
        type: u2
        doc: Character count.
      - id: text
        size: length * 2
        type: str
        encoding: UTF-16BE
  control_word:
    seq:
      - id: value
        type: u2
    instances:
      following:
        pos: _io.pos
        type: u2
