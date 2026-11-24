# Imported from https://github.com/deefha/klan2016-re/blob/e48e34b7abbc9da902e03c0763f48bb7ede2582f/structs/common_header.ksy
meta:
  id: klan_t_header
  title: Klan magazine resource header
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII
  endian: le

doc-ref: https://wiki.klan2016.cz/knihovny/spolecna-hlavicka.html

seq:
  - id: magic
    contents: 'SNOPSoft'
  - id: version
    type: u4
  - id: type
    type: u2
  - id: filesize
    type: u4
  - id: filetime
    type: u2
  - id: filedate
    type: u2
  - id: foo_1
    type: u4
  - id: foo_2
    type: u4
  - id: crc
    type: u2
