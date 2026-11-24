# Imported from https://github.com/dreamingmoths/silent-hill-museum/blob/1c5d033110a77694e7287cf0096ce1f893f8c542/ksy/sh1anm.ksy
meta:
  id: sh1anm
  title: Silent Hill animation format
  file-extension: anm
  license: MIT
  endian: le

doc: |
  Anm is the proprietary 3D animation format of Silent Hill (PSX).

  The body is a list of frames, each frame containing a section of translations
  for the first `num_translation_bones` bones, followed by a section of rotations
  for the next `num_rotation_bones` bones.

  The header contains base translations for all bones, as well as a magic value
  that is the offset to the first frame.

  Some ANMs for the player character contain only a list of frames which are
  appended to a base ANM.

seq:
  - id: magic
    type: s2
    doc: Offset of the first frame (keyframe).

  - id: num_rotations
    type: u1

  - id: num_translations
    type: u1

  - id: frame_size
    type: s2
    valid:
      eq: num_rotations * 9 + num_translations * 3

  - id: num_bones
    type: s2

  - id: flags
    type: s4

  - id: end_ofs
    type: s4

  - id: num_frames
    type: u2

  - id: scale_log2
    type: u1
    doc: translations are scaled by 1 << scale_log2

  - type: u1

  - id: bones
    type: bone
    repeat: expr
    repeat-expr: num_bones

instances:
  frames:
    pos: magic
    type: frame(_index)
    repeat: until
    repeat-until: _io.size - _io.pos < frame_size
    doc: |
      `num_frames` seems to be ignored in practice as the game relies on
      generated `AnimInfo` tables to determine the keyframe limits of each
      animation.

  transforms_per_frame:
    value: num_rotations + num_translations

types:
  frame:
    params:
      - id: frame_index
        type: u2
    seq:
      - id: translations
        type: translation
        repeat: expr
        repeat-expr: _root.num_translations
      - id: rotations
        type: rotation
        repeat: expr
        repeat-expr: _root.num_rotations

  bone:
    seq:
      - id: parent
        type: s1

      - id: rotation_index
        type: s1

      - id: translation_index
        type: s1

      - id: bind_translation
        type: translation

  translation:
    seq:
      - id: x
        type: s1
      - id: y
        type: s1
      - id: z
        type: s1
    instances:
      x_scaled:
        value: (x << _root.scale_log2) / 128.0
        doc: X translation in model units, scaled by `scale_log2`.
      y_scaled:
        value: (y << _root.scale_log2) / 128.0
        doc: Y translation in model units, scaled by `scale_log2`.
      z_scaled:
        value: (z << _root.scale_log2) / 128.0
        doc: Z translation in model units, scaled by `scale_log2`.

  rotation:
    doc: 3x3 matrix, signed fixed point with 7 fraction bits
    seq:
      - id: value
        type: s1
        repeat: expr
        repeat-expr: 9
