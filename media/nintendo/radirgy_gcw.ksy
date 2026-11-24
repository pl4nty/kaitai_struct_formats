# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/gcsw.ksy
meta:
  id: radirgy_gcw
  title: Radirgy GeneriC GameCube sound (.gcw)
  file-extension: gcw
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Radirgy GeneriC GameCube sound (after vgmstream `gcsw.c`). PCM16 BE from 0x20
  with a 0x8000-byte per-channel interleave.
seq:
  - id: magic
    contents: GCSW
  - id: reserved
    size: 4
  - id: sample_rate
    type: u4
  - id: num_channels
    type: u4
  - id: num_samples
    type: u4
  - id: loop_start
    type: u4
  - id: loop_end
    type: u4
  - id: loop_flag
    type: u4
  - id: pcm16
    size-eos: true
