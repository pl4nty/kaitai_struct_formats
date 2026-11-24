# Imported from https://github.com/madwareru/orom-file-formats/blob/8a68f9c2693f9e58d418e4bd6485e14e71efe233/KSY/images/rom_bmp.ksy
# Licence and copyright: see _community/README.md
meta:
  id: rage_of_mages_1_bmp
  title: Rage Of Mages Seal Of Mystery *.bmp image files
  application: Rage Of Mages Seal Of Mystery
  file-extension: bmp
  license: CC0-1.0
  endian: le
doc: This format is just a subtype of a typical bmp file format used in ROM
seq:
  - id: magic
    contents: ["BM"]
  - id: unused0
    type: u4
  - id: unused1
    type: u4
  - id: bfh_pixeldata
    type: u4
  - id: bi_version
    type: u4
  - id: data
    type: bmp_data
    if: (bi_version != 12) and (bi_version == 40)

types:
  bmp_data:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
      - id: bi_planes_unused
        type: u2
      - id: bi_bitcount
        type: u2
      - id: bi_compression_unused
        type: u4
      - id: bi_sizeimage_unused
        type: u4
      - id: bi_xpelspermeter_unused
        type: u4
      - id: bi_ypelspermeter_unused
        type: u4
      - id: bi_clrused_unused
        type: u4
      - id: bi_clrimportant_unused
        type: u4
      - id: palette
        type: u4
        repeat: expr
        repeat-expr: 256
        if: (bi_bitcount == 8)
    instances:
      pixels_data:
        io: _root._io
        pos: _root.bfh_pixeldata
        size: (width * height * bi_bitcount / 8)
