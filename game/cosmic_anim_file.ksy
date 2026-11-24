# Imported from https://github.com/foreverWIP/cosmic/blob/eeb0141db5eb5cafbaed46e0a61f22afc5f87617/Cosmic.Formats/defs/animation_file.ksy
meta:
  id: cosmic_anim_file
  title: Cosmic Engine (Retro Engine v3) animation file
  license: LicenseRef-RSDK-Decompilation-1-C
  imports:
    - cosmic_pascal_string
  endian: le
seq:
  - id: sheet_count
    type: u1
  - id: sheet_names
    type: cosmic_pascal_string
    repeat: expr
    repeat-expr: sheet_count
  - id: anim_count
    type: u1
  - id: anims
    type: animation
    repeat: expr
    repeat-expr: anim_count
  - id: hitbox_count
    type: u1
  - id: hitboxes
    type: hitbox
    repeat: expr
    repeat-expr: hitbox_count
types:
  animation:
    meta:  
      endian: le
    seq:
      - id: name
        type: cosmic_pascal_string
      - id: frame_count
        type: u1
      - id: speed
        type: u1
      - id: loop_index
        type: u1
      - id: rotation_style
        type: u1
      - id: frames
        type: anim_frame
        repeat: expr
        repeat-expr: frame_count
  anim_frame:
    meta:
      endian: le
    seq:
      - id: sheet
        type: u1
      - id: hitbox_id
        type: u1
      - id: spritesheet_x_offset
        type: u1
      - id: spritesheet_y_offset
        type: u1
      - id: width
        type: u1
      - id: height
        type: u1
      - id: pivot_x
        type: s1
      - id: pivot_y
        type: s1
  hitbox:
    meta:
      endian: le
    seq:
      - id: left
        type: s1
      - id: top
        type: s1
      - id: right
        type: s1
      - id: bottom
        type: s1
