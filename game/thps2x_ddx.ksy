# Imported from https://github.com/DCxDemo/LegacyTHPS/blob/075ab69a9b2e7fcd042402cc2cccaf84ccb13e87/formats/thps2x_ddx.ksy
# Licence and copyright: see _community/README.md
meta:
  id: thps2x_ddx
  title: Tony Hawk's Pro Skater 2X texture container
  application: Tony Hawk's Pro Skater 2X
  file-extension: ddx
  license: GPL-3.0-only
  endian: le

doc: |
  Texture container found in Original XBOX game Tony Hawk's Pro Skater 2X. 
  Represents a list of DirectX surfaces (DDS).

doc-ref: https://github.com/DCxDemo/LegacyTHPS/blob/master/formats/thps2x_ddx.ksy

seq:
  - id: reserved # always 0
    type: u4
  - id: file_size # can use to validate
    type: u4
  - id: data_offset # texture array starts here
    type: u4
  - id: num_files
    type: u4
  - id: files
    type: file_entry
    repeat: expr
    repeat-expr: num_files

types:
  file_entry:
    seq:
      - id: offset
        type: u4
      - id: data_size
        type: u4
      - id: name # includes file extension (.DDS)
        size: 256
        type: strz
        encoding: ASCII
    instances:
      data:
        pos: _root.data_offset + offset
        size: data_size
