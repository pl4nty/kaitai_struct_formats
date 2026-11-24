# Imported from https://github.com/Wargus/stargus/blob/b6b90dceb7d327909987580d680b8241bedd568b/src/kaitai/file_tbl.ksy
meta:
  id: starcraft_file_tbl
  title: StarCraft string table (.tbl) file
  license: GPL-2.0-only
  encoding: ASCII
  endian: le
  
seq:
  - id: num_offsets
    type: u2
  # Just read offsets normally
  - id: ofs_files
    type: u2
    repeat: expr
    repeat-expr: num_offsets
instances:
  tbl_entries:
    type: tbl_entry(_index)
    repeat: expr
    repeat-expr: num_offsets
types:
  tbl_entry:
    params:
      - id: i
        type: u2
    instances:
      len:
        value: '_parent.ofs_files[i + 1] - _parent.ofs_files[i]'
      dyn_end:
        value: 'i + 1 < _parent.num_offsets ? len : _io.size - _parent.ofs_files[i]'
      entry:
        pos: _parent.ofs_files[i]
        type: u1
        repeat: expr
        repeat-expr: dyn_end
