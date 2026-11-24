# Imported from https://github.com/the-wondersmith/ferroflex/blob/e2f6a6a2a56903e6ab7bac9284a98d65b2ed4237/docs/kaitai-struct/tag.ksy
meta:
  id: dataflex_tag
  title: DataFlex v2.3 / v3 Database File
  application: DataFlex v2.3 / v3
  file-extension: tag
  license: AGPL-3.0-only
  ks-version: 0.9
  encoding: ASCII
doc: The tag file for a DataFlex flat-file table.
doc-ref: https://web.archive.org/web/20210115231834/hwiegman.home.xs4all.nl/fileformats/dat/DATAFLEX.txt
seq:
  - id: columns
    type: column
    repeat: eos
types:
  column:
    seq:
      - id: name
        type: str
        terminator: 0x0D
        consume: false
      - id: delimiter
        size: 2
        type: str
