# Imported from https://github.com/er1t-h/thl-tools/blob/85a9412058daae0b695230aab67e6ef725569308/resources/mvgl.ksy
meta:
  id: mvgl
  application: The Hundred Line Game Engine
  license: Unlicense
  encoding: UTF-8
  endian: le

seq:
  - id: mdb1
    contents: ["MDB1"]
  - id: file_entry_count
    type: u4
  - id: file_name_count
    type: u4
  - id: number_of_paths
    type: u4
  - id: data_start_offset
    type: u8
  - id: total_size
    type: u8
  - id: marker
    contents: [0xff, 0xff,0xff, 0xff,0xff, 0xff,0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00]
  - id: begin_table_structures
    type: begin_table_structure
    repeat: expr
    repeat-expr: number_of_paths
  - id: padding_before_paths
    type: file_path
  - id: file_paths
    type: file_path
    repeat: expr
    repeat-expr: number_of_paths
  - id: file_size_informations
    type: file_size_information
    repeat: expr
    repeat-expr: number_of_paths

types:
  begin_table_structure:
    seq:
      - id: compare_bit
        type: u4
      - id: id
        type: u4
      - id: left
        type: u4
      - id: right
        type: u4
        
  file_path:
    seq:
      - id: extension
        size: 0x04
        type: str
        terminator: 0x20
      - id: path
        size: 0x7c
        type: strz
  
  file_size_information:
    seq:
      - id: offset
        type: u8
      - id: uncompressed_size
        type: u8
      - id: compressed_size
        type: u8
    instances:
      content:
        pos: _root.data_start_offset + offset
        size: compressed_size
