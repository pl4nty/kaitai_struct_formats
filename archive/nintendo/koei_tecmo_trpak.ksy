# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/switch/trpak.ksy
meta:
  id: koei_tecmo_trpak
  title: Nintendo Switch tr Package archive (Koei Tecmo, .trpak)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Koei Tecmo Switch ".trpak" archive. A minimal FlatBuffers root table
  (`TRPAK { hashes:[ulong]; files:[File] }`); this definition follows the
  fixed root-offset/vtable/vector chain as documented in the source rather
  than a general FlatBuffers reader. `hashes[i]` is an external,
  game-supplied lookup key with no name database in this project.
seq:
  - id: root_offset
    type: u4
  - id: unused_padding
    size-eos: true
instances:
  root_table:
    pos: root_offset
    type: table_ref
types:
  table_ref:
    seq:
      - id: soffset
        type: s4
    instances:
      vtable_pos:
        value: _io.pos - 4 - soffset
      vtable:
        pos: vtable_pos
        type: vtable_t
  vtable_t:
    seq:
      - id: vtable_size
        type: u2
      - id: table_size
        type: u2
  file_entry:
    doc: |
      TRPAK.File: unused:byte, compression_type:byte (255=none,
      3=OODLE), unk1:byte, decompressed_size:ulong, data:[byte]. Not
      expanded further here.
    seq:
      - id: unused
        type: u1
      - id: compression_type
        type: u1
      - id: unk1
        type: u1
