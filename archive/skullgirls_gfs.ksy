# Imported from https://github.com/Skullgirls-Communitys-Cut/Templates/blob/8f3bd2076d7f996f21e1454c054e1bd39d8b80c6/Kaitai/gfs.ksy
meta:
  id: skullgirls_gfs
  title: Skullgirls GFS archive
  license: LicenseRef-All-Rights-Reserved
  endian: be

seq:
  - id: data_offset
    type: u4
  - id: file_identifier_length
    type: u8
  - id: file_identifier
    size: file_identifier_length
    type: str
    encoding: ASCII
  - id: file_version_length
    type: u8
  - id: file_version
    size: file_version_length
    type: str
    encoding: ASCII
  - id: count_of_files
    type: u8
  - id: files_meta_data
    type: file_meta
    repeat: expr
    repeat-expr: count_of_files
  - id: file_data
    size: files_meta_data[_index].file_size
    repeat: expr
    repeat-expr: count_of_files
    
types:
  file_meta:
    seq:
      - id: file_path_length
        type: u8
      - id: reference_path
        size: file_path_length
        type: str
        encoding: ASCII
      - id: file_size
        type: u8
      - id: reference_alignment
        type: u4
