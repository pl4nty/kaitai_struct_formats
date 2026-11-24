meta:
  id: game_4x4_evolution_pod
  title: 4x4 Evolution POD archive
  application: 4x4 Evolution
  file-extension: pod
  license: CC0-1.0
  encoding: UTF-8
  endian: le
doc-ref: 'https://www.watto.org/specs.html?specs=Archive_POD'
seq:
  - id: header
    type: archive_header
  - id: files
    type: file
    repeat: expr
    repeat-expr: header.num_files
types:
  archive_header:
    seq:
      - id: num_files
        type: u4
      - id: description
        size: 80
        type: strz
  file:
    seq:
      - id: file_name
        size: 32
        type: strz
      - id: len_file_data
        type: u4
      - id: ofs_file_data
        type: u4
    instances:
      file_data:
        pos: ofs_file_data
        size: len_file_data
