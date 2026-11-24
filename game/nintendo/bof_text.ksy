# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/bof_text.ksy
meta:
  id: bof_text
  title: Battle of Giants language table (.bof)
  file-extension: bof
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Battle of Giants: Dinosaurs Strike (Wii) language table (one per
  language).
seq:
  - id: version
    type: u4
    doc: '1.'
  - id: num_strings
    type: u4
  - id: num_units
    type: u4
  - id: text_units
    size: num_units * 2
  - id: tail
    size-eos: true
