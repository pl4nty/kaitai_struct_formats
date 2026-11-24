# Imported from https://github.com/gballa/audi_mmi_studio/blob/eb2fb0c3f28b8f65aeb76a4e2cbca784516c02e9/formats/hb_gdb.ksy
# Licence and copyright: see _community/README.md
meta:
  id: hb_gdb
  title: Harman Becker Geographic Routing Database
  file-extension: gdb
  license: Apache-2.0
  endian: be
doc: Harman Becker proprietary compressed road routing network graph.
seq:
  - id: magic
    contents: [0xde, 0xad, 0xbe, 0xef]
  - id: version
    type: u4
  - id: flags
    type: u4
  - id: reserved
    size: 52
  - id: data
    size-eos: true
