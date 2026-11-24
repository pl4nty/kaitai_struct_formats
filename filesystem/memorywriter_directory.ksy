# Imported from https://github.com/pkooiman/Xerox645S_disks/blob/ffda34984f11e8b73afbebbc05c427ff13686cc5/memorywriter_directory.ksy
meta:
  id: memorywriter_directory
  title: Xerox MemoryWriter 645S directory file
  license: LicenseRef-All-Rights-Reserved
  imports:
    - memorywriter_sectoraddress  

seq:
# The directory is a file containing an array of directory entries
  - id: direntries
    type: directory_entry
    repeat: eos
    

types:
  directory_entry:
    seq:
      - id: fileid
        type: u1
        doc: An ID byte that corresponds to the ID byte in the file's sectors
      - id: name
        size: 10
        type: str
        terminator: 0x20
        encoding: UTF-8
        doc: File name, right padded with spaces
      - id: numsectors
        type: u2le
      - id: firstfilesector
        type: memorywriter_sectoraddress
        doc: First sector in the file
      - id: lastfilesector
        type: memorywriter_sectoraddress
        doc: Last sector in the file
      - id: unknown
        type: u1
        repeat: expr
        repeat-expr: 2
      
  
