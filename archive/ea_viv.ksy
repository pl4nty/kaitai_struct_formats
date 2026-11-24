# Imported from https://github.com/e-rk/speedtools/blob/c7b1286fdc0c6983ad121712d90bf0dba7b6a975/speedtools/specs/viv.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ea_viv
  file-extension: viv
  license: CC0-1.0
  imports:
    - fce
    - ctb
    - bnk
    - fedata
  encoding: ASCII
  endian: be
seq:
  - id: magic
    contents: [BIGF]
  - id: size
    type: u4
    doc: Size of the entire file
  - id: num_entries
    type: u4
    doc: Number of directory entries
  - id: unknown
    size: 4
  - id: entries
    type: directory_entry
    repeat: expr
    repeat-expr: num_entries
    doc: Directory entries
types:
  directory_entry:
    seq:
      - id: offset
        type: u4
        doc: Absolute offset of associated data in file
      - id: length
        type: u4
        doc: Length of the associated data
      - id: name
        type: strz
        doc: Name of the directory entry
    instances:
      body:
        pos: offset
        size: length
        type:
          switch-on: name
          cases:
            '"carp.txt"': strz
            '"car.fce"': fce
            '"dash.fce"': fce
            '"hel.fce"': fce
            '"careng.ctb"': ctb
            '"careng.ltb"': ctb
            '"careng.bnk"': bnk
            '"ocareng.bnk"': bnk
            '"scareng.bnk"': bnk
            '"fedata.eng"': fedata
            '"fedata.ger"': fedata
            '"fedata.spa"': fedata
            '"fedata.ita"': fedata
            '"fedata.jap"': fedata
            '"fedata.swe"': fedata
