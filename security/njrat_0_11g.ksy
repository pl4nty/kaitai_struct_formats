# Imported from https://github.com/TeamT5/MalCfgParser/blob/d62d7c38c8e92251ef194aa4988cdc4824a811dd/kaitai_structs/njrat_0_11G.ksy
meta:
  id: njrat_0_11g
  file-extension: njrat_0_11g
  license: LicenseRef-All-Rights-Reserved

seq:
  - id: c2_size
    type: u1
  - id: c2_lists
    size: c2_size
    type: str
    encoding: UTF-8
  - id: directory
    type: unicode_string
  - id: exe_name
    type: unicode_string
  - id: process_protected
    type: unicode_string
  - id: optional
    type: unicode_string
  - id: type2
    type: type2
    if: optional.len > 11
  - id: type1
    type: type1
    if: optional.len <= 11  
types:
  type1:
    seq:
      - id: mutex
        type: unicode_string
      - id: reg_key
        type: unicode_string
      - id: b64_victim_name
        type: unicode_string
      - id: version
        type: unicode_string
  type2:
    seq:
      - id: reg_key
        type: unicode_string
      - id: b64_victim_name
        type: unicode_string
      - id: version
        type: unicode_string
        
  unicode_string:
    seq:
      - id: len
        type: u1
      - id: val
        size: len
        type: str
        encoding: UTF-8
