meta:
  id: aih0
  title: AIH0 firmware container
  license: MIT
  encoding: ASCII
  endian: be
doc-ref: https://github.com/ReFirmLabs/binwalk/blob/563a19d5cb7748da8da2db3ed5ee5c4dd76e8ffe/src/binwalk/magic/firmware#L483
seq:
  - id: header
    size: 48
    type: header
  - id: data
    size: header.len_data
types:
  header:
    seq:
      - id: magic
        contents: 'AIH0'
      - id: unknown_1
        size: 8
      - id: len_data
        type: u4
      - id: unknown_2
        size: 16
      - id: version
        size: 16
        doc: |
          NUL-padded version string, such as "5.00TP" or "4.03"; see
          `version_str`.
    instances:
      version_str:
        io: _parent.header._io
        pos: 0x20
        type: strz
