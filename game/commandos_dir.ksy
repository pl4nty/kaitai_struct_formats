# Imported from https://github.com/YamamotoKaderate/ksy/blob/3d0f0a11362819015a45ea3dc7558b31d8b04ac8/commandos_dir.ksy
# Licence and copyright: see _community/README.md
meta:
  id: commandos_dir
  title: Commandos files archive
  application: Commandos Behind Ennemy Lines
  file-extension: dir
  license: CC0-1.0
  endian: le 
doc-ref: 'http://rewiki.regengedanken.de/wiki/.DIR_(Commandos)'
seq:
  - id: root
    type: dir_begin
types:
  dir_begin:
    seq:
      - id: entry_name
        size: 32
        type: str
        encoding: ASCII
        doc: header of some kind, mostly filled with zeroes
      - id: typ
        type: u1
        enum: entry_type
        doc: type (1 = directory, 0 = file, -1 = end of directory)
      - id: entry_end
        type:
          switch-on: typ
          cases:
            'entry_type::directory': dir_decl
            'entry_type::file': file
            'entry_type::end_of_directory': dir_close
      - id: next
        type: dir_begin
        if: typ != entry_type::end_of_directory
  dir_decl:
    seq:
      - id: unknow1
        type: u1
      - id: unknow2
        type: u1
      - id: unknow3
        type: u1
      - id: size
        type: u4
      - id: offset
        type: u4
    instances:
      sub_entry:
        id: sub
        io: _root._io
        pos: offset
        type: dir_begin
  file:
    seq:
      - id: unknow1
        type: u1
      - id: unknow2
        type: u1
      - id: unknow3
        type: u1
      - id: size
        type: u4
      - id: offset
        type: u4
    instances:
      file_contents:
        io: _root._io
        pos: offset
        size: size
  dir_close:
    seq:
      - id: unknow1
        type: u1
      - id: unknow2
        type: u1
      - id: unknow3
        type: u1
      - id: size
        type: u4
      - id: offset
        type: u4
enums:
  entry_type:
    0x1: directory
    0x0: file
    0xff: end_of_directory

  
