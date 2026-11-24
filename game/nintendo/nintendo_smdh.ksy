# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/smdh.ksy
meta:
  id: nintendo_smdh
  title: Nintendo 3DS SMDH (System Menu Data Header)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Nintendo 3DS application icon + title metadata block, per
  lib-smdh.h. Fixed-size 0x36c0-byte layout, per 3dbrew's SMDH page
  and cross-checked against Gericom's EveryFileExplorer 3DS/SMDH.cs.
seq:
  - id: magic
    contents: "SMDH"
  - id: version
    type: u2
  - id: reserved_06
    type: u2
  - id: titles
    type: title_t
    repeat: expr
    repeat-expr: 16
  - id: settings
    type: settings_t
  - id: reserved_2038
    size: 8
  - id: small_icon
    size: 0x480
    doc: 24x24 RGB565, 8x8-tile Morton-swizzled.
  - id: large_icon
    size: 0x1200
    doc: 48x48 RGB565, same swizzle.
types:
  title_t:
    doc: One per 3DS system language (SMDH_LANG_* order).
    seq:
      - id: short_desc
        size: 0x80
        type: str
        encoding: UTF-16LE
      - id: long_desc
        size: 0x100
        type: str
        encoding: UTF-16LE
      - id: publisher
        size: 0x80
        type: str
        encoding: UTF-16LE
  settings_t:
    seq:
      - id: game_ratings
        size: 0x10
      - id: region_lock
        type: u4
      - id: matchmaker_id
        type: u4
      - id: matchmaker_bit_id
        type: u8
      - id: flags
        type: u4
      - id: eula_version
        type: u2
      - id: reserved
        type: u2
      - id: banner_frame
        type: f4
      - id: streetpass_id
        type: u4
