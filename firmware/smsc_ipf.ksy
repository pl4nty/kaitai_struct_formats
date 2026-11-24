# Imported from https://github.com/gballa/audi_mmi_studio/blob/eb2fb0c3f28b8f65aeb76a4e2cbca784516c02e9/formats/smsc_ipf.ksy
meta:
  id: smsc_ipf
  title: SMSC MOST Intelligent Network Interface Controller Programming File
  file-extension: ipf
  license: MIT OR Apache-2.0
  endian: be
doc: SMSC IPF binary container for flashing OS81050/OS81110 MOST bus controllers.
seq:
  - id: signature
    contents: [0x01, 0x0f, 0xff, 0xff, 0xff, 0xff, 0x01, 0x01, 0x00, 0x00, 0x20, 0x00, 0x00, 0x01, 0xdc, 0x00]
  - id: payload
    size-eos: true
