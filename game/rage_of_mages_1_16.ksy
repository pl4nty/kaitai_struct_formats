# Imported from https://github.com/madwareru/orom-file-formats/blob/8a68f9c2693f9e58d418e4bd6485e14e71efe233/KSY/images/rom_16.ksy
# Licence and copyright: see _community/README.md
meta:
  id: rage_of_mages_1_16
  title: Rage Of Mages Seal Of Mystery *.16 image files
  application: Rage Of Mages Seal Of Mystery
  file-extension: "16"
  license: CC0-1.0
  endian: le
doc: |
  This format contains white texture with 16 degrees of transparency
  Used in the game mainly for fonts
seq:
  - id: sprite_records
    type: sprite_record
    repeat: expr
    repeat-expr: sprite_count

instances:
  sprite_count_internal:
    pos: _io.size - 4
    type: u4
  sprite_count:
    value: sprite_count_internal & 0x7FFFFFFF

types:
  sprite_record:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
      - id: data_size
        type: u4
      - id: data
        size: data_size
