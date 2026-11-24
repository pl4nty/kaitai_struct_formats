# Imported from https://gist.githubusercontent.com/igrr/ab899cef9b121134785a82eaee50ed89/raw/beeb9a318ee60bb287661e6eeef7eb6eb220fd73/esp.ksy
# Try it out by opening https://ide.kaitai.io/ and copying this file there
# Based on an article by @angelcarve about ESP8266 binary image parsing with Kaitai Struct:
#  https://carvesystems.com/news/parsing-binaries-with-kaitai-struct/

meta:
  id: esp_image
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: header
    type: image_header
  - id: extended_header
    type: image_extended_header
  - id: segments
    type: segment
    repeat: expr
    repeat-expr: header.num_segments

types:
  image_header:
    seq:
      - id: magic
        contents: [0xE9]
      - id: num_segments
        type: u1
      - id: flash_mode
        type: u1
        enum: e_flash_mode
      - id: flash_size
        type: b4
        enum: e_flash_size
      - id: flash_freq
        type: b4
        enum: e_flash_freq
      - id: entrypoint
        type: u4
  image_extended_header:
    seq:
      - id: wp_pin
        type: u1
      - id: spi_pin_drv
        size: 3
      - id: chip_id
        type: u2
      - id: min_chip_rev
        type: u1
      - id: reserved
        size: 8
      - id: hash_appended
        type: u1
      
  segment:
    seq:
      - id: load_addr
        type: u4
      - id: segment_size
        type: u4
      - id: segment_data
        size: segment_size

enums:
  e_flash_mode:
    0: qio
    1: qout
    2: dio
    3: dout
  e_flash_size:
    0: size_1m
    1: size_2m
    2: size_4m
    3: size_8m
    4: size_16m
  e_flash_freq:
    0: freq_40mhz
    1: freq_26mhz
    2: freq_20mhz
    0xf: freq_80mhz
