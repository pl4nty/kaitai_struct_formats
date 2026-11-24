# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/apx.ksy
meta:
  id: capcom_apx
  title: Capcom .apx image (Zack & Wiki)
  file-extension: apx
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: Padded to 0x20, then width * height * 3 linear RGB bytes (24-bit files only).
seq:
  - id: file_size
    type: u4
  - id: pixel_bytes
    type: u4
  - id: palette_bytes
    type: u4
  - id: bits_per_pixel
    type: u2
  - id: width
    type: u2
  - id: height
    type: u2
  - id: one
    type: u2
  - id: pad
    size: 0x20 - 0x14
  - id: pixels
    size: pixel_bytes
