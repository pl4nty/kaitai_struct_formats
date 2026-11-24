# Imported from https://github.com/CodeDragon82/reverse-engineering-pmdsky/blob/5c07000ddb8c2cdf4072910693438ce94a418817/tools/pmd2pack.ksy
meta:
  id: pmd2_pack
  title: Pokemon Mystery Dungeon pack file
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: le
    
seq:
  - id: buffer
    type: u4
  - id: file_count
    type: u4
  - id: files
    type: file
    repeat: expr
    repeat-expr: file_count
  
types:
  file:
    seq:
      - id: pointer
        type: u4
      - id: length
        type: u4
    instances:
      data:
        pos: pointer
        size: length
