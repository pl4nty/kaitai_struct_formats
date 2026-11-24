# Imported from https://github.com/the-wondersmith/ferroflex/blob/e2f6a6a2a56903e6ab7bac9284a98d65b2ed4237/docs/kaitai-struct/index.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dataflex_index
  title: DataFlex v2.3 / v3 Index File
  application: DataFlex v2.3 / v3
  file-extension: k*
  license: AGPL-3.0-only
  ks-version: 0.9
  encoding: ASCII
  endian: le
  bit-endian: le
doc: An index file for a DataFlex flat-file table.
doc-ref: https://web.archive.org/web/20210115231834/hwiegman.home.xs4all.nl/fileformats/dat/DATAFLEX.txt
seq:
  - id: index_block
    size: 1024
    type: index_block
    repeat: eos
    
enums:
  enabled_disabled:
    0: disabled
    1: enabled


types:
  index_block:
    instances:
      record_count:
        pos: 0x02
        type: u1
        doc: The total number of records in the block
    # seq:
    #   - id: padding
    #     doc: |
    #       DOCUMENTATION NEEDED
    #     size: 2
    #   - id: record_count
    #     doc: |
    #       DOCUMENTATION NEEDED
    #     type: u1
    #   - id: flag_byte
    #     doc: |
    #       DOCUMENTATION NEEDED
    #     type: u1
