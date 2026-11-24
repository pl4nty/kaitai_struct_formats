# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/effect_list.ksy
meta:
  id: groove_coaster_effect_list
  title: Groove Coaster effect data list
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Container used by effect.dat and consumed by MtxEffectManager. Each adjacent
  offset pair delimits one EffectData buffer (the same payload stored in an
  individual .efcb2 file).
seq:
  - id: file_size
    type: u4
    valid:
      eq: _io.size
  - id: num_effects
    type: u2
  - id: offsets
    type: effect_offset(_index)
    repeat: expr
    repeat-expr: num_effects + 1
types:
  effect_offset:
    params:
      - id: idx
        type: u2
    seq:
      - id: offset
        type: u4
    instances:
      data:
        io: _root._io
        pos: offset
        size: _parent.offsets[idx + 1].offset - offset
        if: idx < _root.num_effects
