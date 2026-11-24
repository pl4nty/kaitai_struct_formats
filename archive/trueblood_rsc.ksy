# Imported from https://github.com/einstein95/kaitai_struct_scripts/blob/e9b7a89aa8d1a82988ea6783b33282bf4a0e918e/trueblood_rsc.ksy
meta:
  id: trueblood_rsc
  title: Trueblood .RSC
  application: "Trueblood: The Karthanian Ultimatum"
  file-extension: rsc
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: num_file_entries
    type: u2
  - id: file_entries
    type: file_entry
    repeat: expr
    repeat-expr: num_file_entries

types:
  file_entry:
    seq:
      - id: len_file_data
        type: u4
      - type: u4
      - id: offset
        type: u4
      - id: file_name
        size: 13
        type: str
        terminator: 0
        encoding: ASCII
    instances:
      file_data:
        pos: offset
        size: len_file_data
