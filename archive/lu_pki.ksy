# Imported from https://github.com/lcdr/lu_formats/blob/eb15852181d3fd55f638eb20ce4a2e9cd7f08dac/files/pki.ksy
meta:
  id: lu_pki
  file-extension: pki
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /database/lu_common
  endian: le
seq:
  - id: version
    contents: [0x03, 0x00, 0x00, 0x00]
  - id: num_file_names
    type: u4
  - id: file_names
    type: lu_common::u4_str
    repeat: expr
    repeat-expr: num_file_names
  - id: num_pack_files
    type: u4
  - id: pack_files
    type: master_pack_index
    repeat: expr
    repeat-expr: num_pack_files
types:
  master_pack_index:
    seq:
      - id: crc
        type: u4
      - id: lower_crc
        type: s4
      - id: upper_crc
        type: s4
      - id: pack_files_index
        type: u4
      - id: is_compressed
        size: 4
        type: lu_common::bool
