# Imported from https://github.com/nt0xa/systembag.kb/blob/c66ae385a99a74ddef106b6343fb42e71a02524d/keybag.ksy
meta:
  id: ios_keybag
  title: iOS keybag
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: data
    type: data
  - id: sign
    type: sign
types:
  data:
    seq:
      - id: tag
        contents: [DATA]
      - id: length
        type: u4
      - id: header
        type: header
      - id: keys
        type: key
        repeat: expr
        repeat-expr: 10
  sign:
    seq:
      - id: tag
        contents: [SIGN]
      - id: length
        type: u4
      - id: body
        size: length
  header:
    seq:
      - id: tags
        type: tag
        repeat: expr
        repeat-expr: 10
  key:
    seq:
      - id: tags
        type: tag
        repeat: expr
        repeat-expr: 5
  tag:
    seq:
      - id: name
        size: 4
        type: str
        encoding: ASCII
      - id: length
        type: u4
      - id: value
        size: length
        type:
          switch-on: length
          cases:
            4: u4
            8: u8
