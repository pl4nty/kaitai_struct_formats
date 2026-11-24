# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/wsbdsp.ksy
meta:
  id: wsbdsp
  title: Star Trek Conquest .WSB sound record table
  file-extension: wsb
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  The sound records sit `count * 0x40 + 4` bytes from the end of the file;
  samples live in the headerless DSP-ADPCM .WSS beside it.
seq:
  - id: one
    type: u4
  - id: header_size
    type: u4
    doc: 0xf4.
  - id: count
    type: u4
  - id: count2
    type: u4
  - id: name
    size: 0xe4
    type: strz
    encoding: ASCII
  - id: rest
    size-eos: true
types:
  sound:
    seq:
      - id: wss_offset
        type: u4
      - id: nibbles
        type: u4
      - id: start_address
        type: u4
        doc: '2.'
      - id: rate
        type: u4
      - id: coefs
        type: s2
        repeat: expr
        repeat-expr: 16
      - id: initial_ps
        type: u4
      - id: hist1
        type: u4
      - id: hist2
        type: u4
      - id: unk
        type: u4
