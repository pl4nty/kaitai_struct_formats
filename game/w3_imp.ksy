# Imported from https://github.com/WaterKnight/Warcraft3-Formats-KaitaiStruct/blob/cdd07826b18f9ec34dfa97c77eb2ff65833f9ddf/w3-imp.ksy
meta:
  id: w3_imp
  title: Warcraft III import list (war3map.imp)
  file-extension: imp
  license: LicenseRef-All-Rights-Reserved
  imports:
    - w3str
  endian: le
seq:
  - id: version
    type: u4
  - id: num_import_obj
    type: u4
  - id: import_obj
    type: import_obj
    repeat: expr
    repeat-expr: num_import_obj
types:
  import_obj:
    seq:
      - id: flags
        type: u1
      - id: path
        type: w3str
