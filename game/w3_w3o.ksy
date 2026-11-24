# Imported from https://github.com/WaterKnight/Warcraft3-Formats-KaitaiStruct/blob/cdd07826b18f9ec34dfa97c77eb2ff65833f9ddf/w3-w3o.ksy
meta:
  id: w3_w3o
  file-extension: w3o
  license: LicenseRef-All-Rights-Reserved
  imports:
    - w3_w3a
    - w3_w3b
    - w3_w3d
    - w3_w3h
    - w3_w3q
    - w3_w3t
    - w3_w3u
  endian: le
seq:
  - id: version
    type: u4
  - id: use_unit
    type: u4
  - id: unit
    type: w3_w3u
    if: use_unit == 1
  - id: use_item
    type: u4
  - id: item
    type: w3_w3t
    if: use_item == 1
  - id: use_destructable
    type: u4
  - id: destructable
    type: w3_w3b
    if: use_destructable == 1
  - id: use_doodad
    type: u4
  - id: doodad
    type: w3_w3d
    if: use_doodad == 1
  - id: use_ability
    type: u4
  - id: ability
    type: w3_w3a
    if: use_ability == 1
  - id: use_buff
    type: u4
  - id: buff
    type: w3_w3h
    if: use_buff == 1
  - id: use_upgrade
    type: u4
  - id: upgrade
    type: w3_w3q
    if: use_upgrade == 1
