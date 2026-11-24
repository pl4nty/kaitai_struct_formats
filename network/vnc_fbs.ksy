# Imported from https://github.com/sibeshkar/jiminy/blob/7754f86fb0f246e7d039ea0cbfd9950fcae4adfb/examples/ksy/fbs.ksy
# Licence and copyright: see _community/README.md
meta:
  id: vnc_fbs
  file-extension: fbs
  license: MIT
  endian: be
seq:
  - id: magic
    type: str
    terminator: 10
    encoding: ASCII
  - id: meta_start
    type: str
    terminator: 10
    encoding: ASCII
  - id: blocks
    type: block
    repeat: until
    repeat-until: _.len == 0
  - id: meta_stop
    type: str
    terminator: 10
    encoding: ASCII
types:
  block:
    seq:
      - id: len
        type: u4
      - id: data
        size: len
      - id: delta_millisec
        type: u4
        if: len != 0
