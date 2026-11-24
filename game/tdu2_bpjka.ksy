# Imported from https://github.com/djey47/tduf-next/blob/707ff9f7742067e989cb231e66e6524c6475fbbe/doc/RE/bpjka/tdu-bpjka.ksy
meta:
  id: tdu2_bpjka
  file-extension: bpjka
  license: MIT
  endian: le
seq:
  - id: tag
    size: 20
    type: str
    encoding: "ASCII"
  - id: unk1
    size: 108
    type: section_1
  - id: unk2
    size-eos: true
    type: section_1
types:
  section_1:
    seq:
      - id: value
        type: f4
        repeat: eos
