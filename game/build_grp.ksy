# Imported from https://github.com/wolfmanfp/kaitai-formats/blob/bebb2549d4bde68f611effd6bdb427044735fd0b/build_grp.ksy
meta:
  id: build_grp
  title: Build Engine group file
  application: Build Engine
  file-extension: grp
  xref:
    wikidata: Q105857126
  license: WTFPL
  endian: le
doc-ref: https://moddingwiki.shikadi.net/wiki/GRP_Format
seq:
  - id: magic
    contents: 'KenSilverman'
  - id: file_count
    type: u4
  - id: file_entries
    type: file_entry
    repeat: expr
    repeat-expr: file_count
  - id: file_bodies
    size: file_entries[_index].size
    repeat: expr
    repeat-expr: file_count
types:
  file_entry:
    seq:
      - id: filename
        size: 12
        terminator: 0
      - id: size
        type: u4
    
