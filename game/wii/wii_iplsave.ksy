# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/system/iplsave.ksy
meta:
  id: wii_iplsave
  application: Wii Menu
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: magic
    size: 4
    type: str
    encoding: UTF-8
    doc: Always RIPL.
  - id: filesize
    type: u4
  - id: header_unknown
    size: 8
    doc: Two u32 words (3, 0 in a Dolphin-created save).
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: 48
  - id: unknown_tail
    size: filesize - 0x10 - 48 * 16 - 16
    doc: |
      Remaining bytes between the channel entries and the MD5 (416 in a
      Dolphin-created save).
  - id: md5_sum
    size: 16
types:
  entry:
    seq:
      - id: channel_type
        type: u1
        doc: 0 for no channel, 1 for Disc Channel, 3 for normal channels
      - id: secondary_type
        type: u1
        doc: |
          0 for normal channels, 1 for Disc Channel, Mii Channel, Wii Shop Channel and
          Photo Channel
      - id: unknown
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: All titles set to 0?
      - id: flags
        type: u2
        doc: All titles except the Disc Channel use 14, which uses 15.
      - id: title_id
        type: u8
