# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/capcom_gml1.ksy
meta:
  id: capcom_gml1
  title: Capcom Ghost Trick GML1 script container (.xml.bin)
  file-extension: xml.bin
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  `1LMG` script binary of Ghost Trick: Phantom Detective (18 retail
  `.xml.bin` files, 929 inner `.xml.lz` files).
seq:
  - id: magic
    contents: '1LMG'
    doc: '`GML1` read backwards (little-endian `0x474D4C31`).'
  - id: flags
    type: u4
    doc: 0 for dialogue / database scripts, 102 for system menus.
  - id: data_length
    type: u4
    doc: Length of the data / bytecode section.
  - id: control_entry_count
    type: u4
  - id: key_table_offset
    type: u4
  - id: header_rest
    size: 48 - 0x14
  - id: data
    size: data_length
    doc: Bytecode, localized text blocks and index tables.
  - id: trailer
    size-eos: true
