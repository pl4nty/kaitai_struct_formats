# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/aiffwav.ksy
meta:
  id: aiffwav
  title: AIFF / AIFF-C audio
  file-extension: aif
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Big-endian IFF container ("FORM"); COMM {s16 channels, u32 frames, s16 bits,
  80-bit rate}, SSND {u32 offset, u32 block size, data}. Converted to WAV.
seq:
  - id: magic
    contents: FORM
  - id: size
    type: u4
  - id: form_type
    size: 4
    type: str
    encoding: ASCII
  - id: chunks
    type: chunk
    repeat: eos
types:
  chunk:
    seq:
      - id: tag
        size: 4
        type: str
        encoding: ASCII
      - id: size
        type: u4
      - id: body
        size: size
      - id: pad
        size: size % 2
