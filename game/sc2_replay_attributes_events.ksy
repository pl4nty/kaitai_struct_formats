# Imported from https://github.com/hotsbuff/stormprotocol/blob/1210687a122e8515aeb3e9338810db36f1dcfe5c/formats/attributes_events.ksy
meta:
  id: sc2_replay_attributes_events
  title: StarCraft II replay attributes events
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: source
    type: u1
  - id: map_namespace
    type: u4
  - id: reserved
    type: u4
  - id: entries
    type: attribute
    repeat: eos
types:
  attribute:
    seq:
      - id: namespace
        type: u4
      - id: id
        type: u4
      - id: scope
        type: u1
      - id: value
        size: 4
