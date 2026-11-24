# Imported from https://github.com/cyrozap/mediatek-lte-baseband-re/blob/8c01efae5a9784ec8c84b4a4087678860de98e20/BP/mediatek_dbginfo.ksy
# Licence and copyright: see _community/README.md
meta:
  id: mediatek_dbginfo
  title: MediaTek Modem Debug Info
  license: CC0-1.0
  endian: le
seq:
  - id: header
    type: header
instances:
  symbols:
    pos: header.symbols_start
    size: header.file_associations_start - header.symbols_start - 1
    type: symbols
  file_associations:
    pos: header.file_associations_start
    size: _io.size - header.file_associations_start - 1
    type: file_associations
types:
  header:
    seq:
      - id: magic
        size: 4
        type: str
        encoding: ASCII
      - id: ver
        type: u4
      - id: unk
        type: u4
      - id: version
        type: strz
        encoding: ASCII
      - id: platform
        type: strz
        encoding: ASCII
      - id: build_name
        type: strz
        encoding: ASCII
      - id: build_time
        type: strz
        encoding: ASCII
      - id: symbols_start
        type: u4
      - id: file_associations_start
        type: u4
  symbols:
    seq:
      - id: symbol
        type: symbol
        repeat: eos
  symbol:
    seq:
      - id: name
        type: strz
        encoding: ASCII
      - id: start
        type: u4
      - id: end
        type: u4
  file_associations:
    seq:
      - id: file_association
        type: file_association
        repeat: eos
  file_association:
    seq:
      - id: file
        type: strz
        encoding: UTF-8
      - id: range_count
        type: u4
      - id: symbol_range
        type: symbol_range
        repeat: expr
        repeat-expr: range_count
  symbol_range:
    seq:
      - id: start
        type: u4
      - id: end
        type: u4
