# Imported from https://github.com/gballa/audi_mmi_studio/blob/eb2fb0c3f28b8f65aeb76a4e2cbca784516c02e9/formats/hb_grammar.ksy
# Licence and copyright: see _community/README.md
meta:
  id: hb_grammar
  title: Harman Becker Binary Grammar Resource
  file-extension: hbgr
  license: Apache-2.0
  endian: le
doc: Harman Becker compiled binary grammar resource for acoustic prompts and TTS.
seq:
  - id: signature
    contents: [0xfe, 0xff, 0xff, 0xff]
  - id: header_length
    type: u4
  - id: header_text
    size: header_length - 8
    type: str
    encoding: ASCII
  - id: body
    size-eos: true
