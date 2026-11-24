# Imported from https://github.com/the-wondersmith/ferroflex/blob/e2f6a6a2a56903e6ab7bac9284a98d65b2ed4237/docs/kaitai-struct/filelist.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dataflex_filelist
  title: DataFlex v2.3 / v3 Filelist
  application: DataFlex v2.3 / v3
  file-extension: cfg
  license: AGPL-3.0-only
  ks-version: 0.9
  encoding: ASCII
doc: A DataFlex table file list.
doc-ref: https://web.archive.org/web/20210115231834/hwiegman.home.xs4all.nl/fileformats/dat/DATAFLEX.txt
seq:
  - id: header
    size: 128
    type: strz
    doc: This is usually just 'filelist.cfg' + 116 bytes of padding.
  - id: tables
    type: entry
    repeat: eos
types:
  entry:
    seq:
      - id: root_name
        size: 41
        type: strz
        doc: The root name of the table's .DAT file
      - id: table_name
        size: 33
        type: strz
        doc: The table's human-readable name
      - id: description
        size: 54
        type: strz
        doc: A description of the table's use or purpose
