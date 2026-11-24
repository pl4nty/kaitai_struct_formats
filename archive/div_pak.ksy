# Imported from https://github.com/AzazelN28/div-tools/blob/188127dfc552063452ff8e092511e6ab77d74823/formats/pak.ksy
meta:
  id: div_pak
  title: DIV Games Studio PAK archive
  file-extension: pak
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII #cp850
  endian: le

seq:
  - id: header
    type: header
  - id: id
    type: u4
    repeat: expr
    repeat-expr: 3
  - id: num_files
    type: u4
  - id: files
    type: file

types:
  header:
    seq:
      - id: magic
        contents: ["dat", 0x1A, 0x0D, 0x0A, 0]
      - id: version
        type: u1
  file:
    seq:
      - id: filename
        size: 16
        type: strz
      - id: offset
        type: s4
      - id: compressed
        type: s4
      - id: uncompressed
        type: s4
