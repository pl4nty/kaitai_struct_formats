# Imported from https://github.com/atylo/automation-scripts/blob/2a762a1c6375655318c0935258e0a430bb4c5798/ProjectEGG/Kaitai%20Struct%20schemes/d88.ksy
meta:
  id: d88
  title: D88 Disk Image Format
  file-extension: d88
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: disk_name
    size: 16
    type: str
    encoding: Shift_JIS
  - id: comment_terminator
    type: u1
  - id: reserved
    size: 9
  - id: write_protect_flag
    type: u1
  - id: media_flag # 00h = 2D, 10h = 2DD, 20h = 2HD.
    type: u1
  - id: disk_size
    type: u4
  - id: track_table
    type: u4
    repeat: expr
    repeat-expr: 164 #track_table != "0"
  #- id: paddding
  #  size: track_table + 200
  - id: data_area
    type: track
    repeat: until
    repeat-until: _io.eof

types:

  track:
    seq:
      - id: sectors
        type: sector_head
      - id: sector_data
        #size: sectors.data_size_sans_head
        size: 128 << sectors.sector_size
        #repeat: until
        #repeat-until: sectors.decr != 0

  sector_head:
    seq:
      - id: cylinder_id
        type: u1
      - id: head_id
        type: u1
      - id: sector_id
        type: u1
      - id: sector_size
        type: u1 
      - id: num_sectors
        type: u2
      - id: density_flag
        type: u1
      - id: deleted_data_flag
        type: u1
      - id: fdc_status_code
        type: u1
      - id: reserved
        size: 5
      - id: data_size_sans_head
        type: u2
    instances:
      decr:
        value: num_sectors - sector_id
