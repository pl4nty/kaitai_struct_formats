# Imported from https://github.com/jankais3r/Clearwell-backup-extractor/blob/cc4d5dcce405e4bf313e925763acbccf0c7890e0/format.ksy
meta:
  id: clearwell_bak
  title: Clearwell .BAK backup
  application: Clearwell
  file-extension: bak
  license: MIT
  endian: be
  
seq:
  - id: root_folders
    type: root_folder
    
  - id: bak_objects
    type: bak_object
    repeat: until
    repeat-until: _.end_byte == [0x45]
    
types:
  root_folder:
    seq:
      - id: object_type
        type: u1
        enum: object_type
        
      - id: root_folder_name_length
        type: u2
        
      - id: root_folder_name
        size: root_folder_name_length
        type: str
        encoding: UTF-8
        
      - id: spacer_1
        contents: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        
  bak_object:
    seq:
      - id: folder_id_start
        size: 3
        if: next_byte != [0x44] and next_byte != [0x46] and (dir_spec == [0x01, 0x44] or dir_spec == [0x01, 0x46])
        
      - id: divider
        contents: [1]
        if: next_byte2 == [0x01]
        
      - id: object_type
        type: u1
        enum: object_type
        
      - id: name_length
        type: u2
        
      - id: name
        size: name_length
        type: str
        encoding: UTF-8
        
      - id: spacer_1
        contents: [0, 0, 0, 0, 0]
        
      - id: folder_id_end
        size: 3
        
      - id: spacer_2
        contents: [0, 0, 0, 0, 0]
        if: object_type == object_type::directory
        
      - id: file_size
        type: u8
        if: object_type == object_type::file
        
      - id: spacer_3
        contents: [0, 0]
        if: object_type == object_type::file
        
      - id: timestamp
        size: 6
        if: object_type == object_type::file
        
      - id: divider_2
        contents: [1]
        if: object_type == object_type::file
        
      - id: file_contents
        size: file_size
        if: object_type == object_type::file
        
    instances:
      next_byte:
        pos: _io.pos
        size: 1
        
      next_byte2:
        pos: _io.pos
        size: 1
        
      dir_spec:
        pos: _io.pos + 3
        size: 2
        
      end_byte:
        pos: _io.pos
        size: 1
        
enums:
  object_type:
    0x44: directory
    0x46: file
