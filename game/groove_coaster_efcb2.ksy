# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/efcb2.ksy
meta:
  id: groove_coaster_efcb2
  title: Groove Coaster effect buffer
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Header and field directory recovered from EffectData::GetDataIndex,
  GetBlendMode, CalcFieldCount, FindKey, and InterpolateKey. Every field has
  five channel offsets. The channels are field-specific data, translation
  XYZ, color RGBA, scale XY, and rotation. Key records contain a frame,
  interpolation mode, float components, and a possible type-specific byte
  tail.
seq:
  - id: max_frame
    type: u2
  - id: num_fields
    type: u1
  - id: fields
    type: field_ref(_index)
    repeat: expr
    repeat-expr: num_fields
types:
  field_ref:
    params:
      - id: idx
        type: u1
    seq:
      - id: offset
        type: u2
    instances:
      field:
        io: _root._io
        pos: offset
        type: effect_field(offset)
  effect_field:
    params:
      - id: base_offset
        type: u2
    seq:
      - id: field_type
        type: u1
        doc: |
          Rendering type. Confirmed consumers include 2 = textured sprite,
          3 = rectangle, 5 = nested effect, and 6 = circle. Type 0 is used as
          a non-drawing control/transform field in the samples.
      - id: data_index
        type: u2
        doc: Resource index; its target depends on field_type.
      - id: blend_mode
        type: u1
        doc: Stored mode 0..5 maps to MtxGraphics3D blend mode 1..6.
      - id: flags
        type: u1
        doc: Bit/boolean controlling inheritance from the previous field.
      - id: channel_offsets
        type: channel_ref(_index)
        repeat: expr
        repeat-expr: 5
    instances:
      num_values:
        value: 'field_type == 0 ? 1 : field_type == 1 ? 0 : field_type == 2 ? 7 : field_type == 3 ? 4 : field_type == 4 ? 13 : field_type == 5 ? 3 : field_type == 6 ? 2 : field_type == 7 ? 0 : field_type == 8 ? 3 : field_type == 9 ? 4 : field_type == 10 ? 2 : field_type == 11 ? 1 : 0'
      primary_key_size:
        value: 'field_type == 0 ? 7 : field_type == 1 ? 3 : field_type == 2 ? 31 : field_type == 3 ? 19 : field_type == 4 ? 45 : field_type == 5 ? 15 : field_type == 6 ? 11 : field_type == 7 ? 0 : field_type == 8 ? 15 : field_type == 9 ? 19 : field_type == 10 ? 11 : field_type == 11 ? 7 : 0'
  channel_ref:
    params:
      - id: idx
        type: u1
    seq:
      - id: relative_offset
        type: u2
        doc: Offset relative to the start of this effect field.
    instances:
      channel:
        io: _root._io
        pos: _parent.base_offset + relative_offset
        type: 'key_channel(idx == 0 ? _parent.primary_key_size : idx == 1 ? 15 : idx == 2 ? 19 : idx == 3 ? 11 : 7)'
        if: 'relative_offset >= 15 and _parent.base_offset + relative_offset < _root._io.size'
  key_channel:
    params:
      - id: key_size
        type: u1
    seq:
      - id: num_keys
        type: u2
      - id: loop_start
        type: u2
      - id: loop_end
        type: u2
      - id: keys
        type: key_record(key_size)
        repeat: expr
        repeat-expr: num_keys
  key_record:
    params:
      - id: record_size
        type: u1
    seq:
      - id: frame
        type: u2
      - id: interpolation
        type: u1
        enum: interpolation_modes
      - id: values
        type: f4
        repeat: expr
        repeat-expr: (record_size - 3) / 4
      - id: tail
        size: (record_size - 3) % 4
enums:
  interpolation_modes:
    0: step
    1: linear
