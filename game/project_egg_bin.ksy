# Imported from https://github.com/einstein95/project_egg/blob/83283833bfb5cf42a4e52ea6e5d7b7112147415a/project_egg_bin.ksy
meta:
  id: project_egg_bin
  title: Project EGG .bin
  file-extension: bin
  license: MIT
  endian: le
  bit-endian: le  # so we don't need b7 padding

seq:
  - id: idstring
    size: 8
    type: str
    encoding: ASCII
  - id: filesize
    type: u4
  - id: data_off
    type: u4
  - id: num_files
    type: u4
  - id: filename_csv
    type: file_names
    repeat: expr
    repeat-expr: num_files
  - id: files
    type: file(_index)
    repeat: expr
    repeat-expr: num_files

types:
  file_names:
    seq:
      - id: file_name
        type: str
        terminator: 0x2C  # ,
        encoding: Shift_JIS
      - id: file_type
        type: str
        terminator: 0x2C  # ,
        encoding: Shift_JIS

  file:
    params:
      - id: i
        type: u4
    seq:
      - id: compressed
        type: b1
      - id: type
        type: u1
        enum: file_type
      - id: size
        type: u4
      - id: body
        type:
          switch-on: compressed
          cases:
            true: compressed_data
            false: uncompressed_data
    instances:
      filename:
        value: _root.filename_csv[i].file_name
    enums:
      file_type:
        1: readme
        2: license  # kyodaku / 許諾
        3: data
        11: game
  
  compressed_data:
    seq:
      - id: decompressed_size
        type: u4
      - id: file_data
        size: _parent.size - 4
  
  uncompressed_data:
    seq:
      - id: file_data
        size: _parent.size
