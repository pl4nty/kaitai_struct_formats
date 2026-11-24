# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/nds_rrds.ksy
meta:
  id: nds_rrds
  title: Next Level Games / Namco DS RRDS mono IMA-ADPCM sound
  file-extension: rrds
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: Metroid Prime Hunters, Ridge Racer DS. ".rrds" is a made-up extension.
seq:
  - id: data_end
    type: u4
    doc: +0x18 = file size.
  - id: unk4
    size: 4
  - id: rate
    type: u4
  - id: unk0c
    size: 8
  - id: loop_byte_offset
    type: u4
  - id: predictor
    type: s2
  - id: step_index
    type: u2
  - id: nibbles
    size-eos: true
