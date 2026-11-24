# Imported from https://github.com/fpv-wtf/ar-firmware-tools/blob/74a9c3573388660c2600c0d2ecc4045ce0698278/otra_spl.ksy
# Licence and copyright: see _community/README.md
meta:
  id: artosyn_otra_spl
  file-extension: img
  license: MIT
  endian: le
seq:
  - id: header
    type: header
  - id: spl
    size: header.spl_len
  - id: troot
    size: header.troot_len
  - id: signature
    size: header.signature_len
     
types:
  header:
    seq:
      - id: magic
        contents: "OTRA"
      - id: version
        type: u4
      - id: img_type
        type: u4
      - id: spl_load_addr
        type: u4
      - id: spl_len
        type: u4
      - id: troot_load_addr
        type: u4
      - id: troot_len
        type: u4
      - id: signature_load_addr
        type: u4
      - id: signature_len
        type: u4
      - id: checksum
        type: u4
      - id: reserved
        size: 4*6
      
