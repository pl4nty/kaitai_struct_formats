# Imported from https://github.com/PierreBelmondo/vscode-wipeout/blob/fde78f7b7e257a22378d2c8c498cc38d0b1bdfc5/resources/kaitai/wac.ksy
# Licence and copyright: see _community/README.md
meta:
  id: wipeout_wac
  file-extension: wac
  license: MIT
  endian: le

seq:
  - id: folder
    type: folder

types:
  folder:
    seq:
      - id: files_count
        type: u4
      - id: folders_count
        type: u4
      - id: name_offset
        type: u4
      - id: files_table_offset
        type: u4
      - id: folders_table_offset
        type: u4
        
    instances:
      name:
        pos: name_offset
        type: str
        terminator: 0
        encoding: ASCII
      files:
        pos: files_table_offset
        type: file_offset
        repeat: expr
        repeat-expr: files_count
      folders:
        pos: folders_table_offset
        type: folder_offset
        repeat: expr
        repeat-expr: folders_count

  file:
    seq:
      - id: name_offset
        type: u4
      - id: size
        type: u4
      - id: dummy
        type: u4
      - id: offset
        type: u4
    instances:
      name:
        pos: name_offset
        type: str
        terminator: 0
        encoding: ASCII
        
  folder_offset:
    seq:
      - id: offset
        type: u4
    instances:
      file:
        pos: offset
        type: folder
        
  file_offset:
    seq:
      - id: offset
        type: u4
    instances:
      file:
        pos: offset
        type: file
        
