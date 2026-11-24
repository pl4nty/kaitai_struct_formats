# Imported from https://github.com/gballa/audi_mmi_studio/blob/eb2fb0c3f28b8f65aeb76a4e2cbca784516c02e9/formats/adi_ldr.ksy
# Licence and copyright: see _community/README.md
meta:
  id: adi_ldr
  title: Analog Devices Blackfin DSP Loader Executable
  file-extension: ldr
  license: Apache-2.0
  endian: le
doc: Analog Devices VisualDSP++ LDR boot stream format for ADSP-BF5xx Blackfin DSPs.
seq:
  - id: magic
    contents: [0xe2, 0xd3, 0xc6, 0xb8]
  - id: header_size
    type: u4
  - id: target_processor
    type: u4
  - id: timestamp
    type: u4
  - id: reserved
    size: header_size - 16
  - id: stream_data
    size-eos: true
