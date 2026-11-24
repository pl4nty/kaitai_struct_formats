# Imported from https://github.com/CodeDragon82/reverse-engineering-pmdsky/blob/5c07000ddb8c2cdf4072910693438ce94a418817/tools/pkdpx.ksy
meta:
  id: pmd_pkdpx
  title: Pokemon Mystery Dungeon PKDPX compressed file
  file-extension: pkdpx
  license: LicenseRef-All-Rights-Reserved
  endian: le
  
seq:
  - id: magic
    contents: "PKDPX"
  - id: length
    type: u2
  - id: controls_flags
    size: 9
  - id: decompressed_length
    type: u4
  - id: data
    size: length - 20
