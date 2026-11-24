# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/switch/sharc.ksy
meta:
  id: nintendoware_sharc
  title: NintendoWare Shader Source Archive (.sharc / AAHS)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  NintendoWare shader source archive (checked against KillzXGaming/Switch-Toolbox
  Shader/SHARC/SHARC.cs). Every program/source entry starts
  with its own section_size covering itself, so entries can be walked
  without understanding the version-dependent shader-variation payload
  inside them; that payload is left raw here.
seq:
  - id: magic
    contents: "AAHS"
  - id: version
    type: u4
  - id: file_size
    type: u4
  - id: bom
    type: u4
  - id: name_length
    type: u4
  - id: name
    size: name_length
    type: str
    encoding: UTF-8
  - id: source_array_offset
    type: u4
    doc: Relative to the position right after this field.
  - id: program_count
    type: u4
  - id: programs
    type: self_delimited_entry
    repeat: expr
    repeat-expr: program_count
types:
  self_delimited_entry:
    seq:
      - id: section_size
        type: u4
        doc: Byte count including this field, measured from the entry's own start.
      - id: body
        size: section_size - 4
  source_section:
    seq:
      - id: source_section_size
        type: u4
      - id: source_file_count
        type: u4
      - id: sources
        type: self_delimited_entry
        repeat: expr
        repeat-expr: source_file_count
