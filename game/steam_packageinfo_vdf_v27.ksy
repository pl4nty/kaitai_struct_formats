# Imported from https://github.com/Tschrock/ksy-formats/blob/c10c1ff7b6aa7fd1522a601ac209fa92d73e1349/steam/packageinfo_vdf.old.ksy
meta:
  id: steam_packageinfo_vdf_v27
  title: Steam's 'packageinfo.vdf' file. (before april 2020)
  application: Steam
  file-extension: vdf
  license: LicenseRef-All-Rights-Reserved
  imports:
    - binary_vdf
  endian: le
doc-ref: https://github.com/SteamDatabase/SteamAppInfo/blob/17f17f46868a196752134d150f48310fd287f56f/README.md#packageinfovdf-before-april-2020
seq:
  - id: magic
    contents: [0x28, 0x55, 0x56, 0x06]
  - id: universe
    type: u4
  - id: sections
    type: test
    repeat: until
    repeat-until: _.next_u4 == 0xFFFFFFFF
    if: next_u4 != 0xFFFFFFFF
  - id: eof
    contents: [0xFF, 0xFF, 0xFF, 0xFF]
instances:
  next_u4:
    pos: _io.pos
    type: u4
types:
  test:
    seq:
      - id: body
        type: section
    instances:
      next_u4:
        pos: _io.pos
        type: u4
  section:
    seq:
      - id: package_id
        type: u4
      - id: sha1
        size: 20
      - id: change_number
        type: u4
      - id: binary_vdf
        type: binary_vdf
