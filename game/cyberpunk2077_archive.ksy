# Imported from https://gist.githubusercontent.com/rfuzzo/2b4e366b6551934337d804ead5b36744/raw/1221910924d6c173e0ff0f11b63d674fc011cdbb/cp77_archive_ksy
meta:
  id: cyberpunk2077_archive
  title: Cyberpunk 2077 archive (.archive)
  file-extension: archive
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: header
    type: ar_header

instances:
  table_inst:
    pos: header.tableoffset
    size: header.tablesize
    type: ar_table
  
    
types: 
  ar_header:
    seq:
      - id: magic
        contents: [0x52, 0x44, 0x41, 0x52]
      - id: version
        type: u4
      - id: tableoffset
        type: u8
      - id: tablesize
        type: u8
      - id: unk3
        type: u8
      - id: filesize
        type: u8
  ar_table:
    seq:
      - id: num
        type: u4
      - id: size
        type: u4
      - id: checksum
        type: u8
      - id: table1count
        type: u4
      - id: table2count
        type: u4
      - id: table3count
        type: u4
      - id: table1entries
        type: table1entry
        repeat: expr
        repeat-expr: table1count
      - id: table2entries
        type: table2entry
        repeat: expr
        repeat-expr: table2count
      - id: table3entries
        type: table3entry
        repeat: expr
        repeat-expr: table3count
  table1entry:
    seq:
      - id: start
        size: 16
      - id: somebool
        type: u4
      - id: startindex
        type: u4
      - id: nextindex
        type: u4
      - id: unk4
        type: u4
      - id: unk5
        type: u4
      - id: end
        size: 20
          
  table2entry:
    seq:
      - id: offset
        type: u8
      - id: zsize
        type: u4
      - id: size
        type: u4
  table3entry:
    seq:
      - id: hash
        type: u8
