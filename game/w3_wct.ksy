# Imported from https://github.com/WaterKnight/Warcraft3-Formats-KaitaiStruct/blob/cdd07826b18f9ec34dfa97c77eb2ff65833f9ddf/w3-wct.ksy
meta:
  id: w3_wct
  title: Warcraft III custom trigger text (war3map.wct)
  file-extension: wct
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: version
    type: version
  - id: head_comment
    type: strz
    encoding: UTF-8
    if: version.val == 1
  - id: head_trigger
    type: trigger
    if: version.val == 1
  - id: num_trigger
    type: u4
  - id: trigger
    type: trigger
    repeat: expr
    repeat-expr: num_trigger
types:
  version:
    seq:
      - id: first_version
        type: u4
      - id: second_version
        type: u4
        if: first_version == 0x80000004
    instances:
      val:
        value: "(first_version == 0x80000004 ? second_version : first_version)"
  trigger:
    seq:
      - id: length
        type: u4
      - id: content
        size: length
        type: str
        encoding: UTF-8
