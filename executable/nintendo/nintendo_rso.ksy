# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/rso.ksy
meta:
  id: nintendo_rso
  title: Nintendo RSO relocatable static object module (GameCube/Wii)
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Nintendo "RSO" module (GameCube/Wii PowerPC dynamically loadable
  code/data), per lib-rso.h. No magic signature; the module-list
  pointers are always zero on disk. Only the section table needed to
  recover payloads is modeled; prolog/epilog/import/export tables
  documented in the source as existing further in the header are
  not covered here.
seq:
  - id: next
    type: u4
    doc: Module list pointer; always 0 on disk.
  - id: prev
    type: u4
    doc: Module list pointer; always 0 on disk.
  - id: num_sections
    type: u4
  - id: section_info_offset
    type: u4
  - id: name_offset
    type: u4
  - id: name_size
    type: u4
    doc: Byte length, excluding the NUL.
  - id: version
    type: u4
  - id: bss_size
    type: u4
instances:
  sections:
    io: _io
    pos: section_info_offset
    type: section_t
    repeat: expr
    repeat-expr: num_sections
  name:
    io: _io
    pos: name_offset
    size: name_size
    type: str
    encoding: ASCII
types:
  section_t:
    seq:
      - id: raw_offset
        type: u4
        doc: Low bit set marks a BSS section (no on-disk payload).
      - id: size
        type: u4
    instances:
      is_bss:
        value: raw_offset & 1
      offset:
        value: raw_offset & ~1
      body:
        io: _root._io
        pos: offset
        size: size
        if: is_bss == 0
