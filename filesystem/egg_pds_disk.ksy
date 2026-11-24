# Imported from https://github.com/atylo/automation-scripts/blob/2a762a1c6375655318c0935258e0a430bb4c5798/ProjectEGG/Kaitai%20Struct%20schemes/EGG_pds_disk.ksy
meta:
  id: egg_pds_disk # special ProjectEGG format for diskettes, similar to d88
  title: Project EGG PDS disk image
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: magic
    size: 4
    type: str
    encoding: ASCII
  - id: disk_type # 0 - 84, 1 or 2 - 168 tracks
    type: u1
  - id: track
    type: track
    repeat: until
    repeat-until: _.num_of_sectors == 0


  
types:
  track:
    seq:
      - id: num_of_sectors
        type: u1
      - id: sectors
        type: sector
        repeat: expr
        repeat-expr: num_of_sectors
  sector:
    seq:
      - id: sheader
        type: sector_head
      - id: sector_data
        size: sheader.size_factor << 7 # like in the code

  sector_head:
    seq:
      - id: cylinder_id
        type: u1
      - id: head_id
        type: u1
      - id: sector_num
        type: u1
      - id: n_code
        type: u1
      - id: status
        type: u1
        if: status != 64
      - id: size_factor
        type: u1
    
