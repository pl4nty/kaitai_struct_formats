meta:
  id: mmd_vmd
  title: MMD (MikuMikuDance) motion data
  application: MikuMikuDance
  file-extension: vmd
  license: MIT
  encoding: Shift_JIS
  endian: le

doc: |
  VMD is the format used by MikuMikuDance (MMD) for storing animation data.
  A VMD file can contain data for character motion and cameras, but VMD
  files tend to contain either one or the other, not both.

seq:
  - id: header
    type: header
  - id: motion_count
    type: u4
  - id: motions
    type: motion
    repeat: expr
    repeat-expr: motion_count
  - id: morph_count
    type: u4
  - id: morphs
    type: morph
    repeat: expr
    repeat-expr: morph_count
  - id: camera_count
    type: u4
  - id: cameras
    type: camera
    repeat: expr
    repeat-expr: camera_count
  - id: light_count
    type: u4
    if: not _io.eof
    doc: |
      This and all following sections are optional: older writers end the
      file after the camera (or light) keyframes.
  - id: lights
    type: light
    repeat: expr
    repeat-expr: light_count
    if: not _io.eof
  - id: self_shadow_count
    type: u4
    if: not _io.eof
  - id: self_shadows
    type: self_shadow
    repeat: expr
    repeat-expr: self_shadow_count
    if: not _io.eof
  - id: ik_frame_count
    type: u4
    if: not _io.eof
  - id: ik_frames
    type: ik_frame
    repeat: expr
    repeat-expr: ik_frame_count
    if: not _io.eof

types:

  header:
    seq:
      - id: magic
        contents: "Vocaloid Motion Data 0002"
      - id: magic_padding
        size: 5
        doc: |
          Rest of the 30-byte signature field. It starts with a NUL
          terminator, but writers often leave garbage after it, and readers
          only check the first 25 bytes.
      - id: name
        size: 20
        type: strz

  motion:
    seq:
      - id: bone_name
        size: 15
        type: strz
      - id: frame_number
        type: u4
      - id: position
        type: vec3
      - id: rotation
        type: vec4
      - id: interpolation
        type: u1
        repeat: expr
        repeat-expr: 64

  morph:
    seq:
      - id: morph_name
        size: 15
        type: strz
      - id: frame_number
        type: u4
      - id: weight
        type: f4

  camera:
    seq:
      - id: frame_number
        type: u4
      - id: distance
        type: f4
      - id: position
        type: vec3
      - id: rotation
        type: vec3
      - id: interpolation
        type: u1
        repeat: expr
        repeat-expr: 24
      - id: fov
        type: u4
      - id: perspective
        type: u1

  light:
    seq:
      - id: frame_number
        type: u4
      - id: color
        type: vec3
        doc: RGB, each component from 0.0 to 1.0
      - id: direction
        type: vec3

  self_shadow:
    seq:
      - id: frame_number
        type: u4
      - id: mode
        type: u1
        doc: 0 = off, 1 = mode 1, 2 = mode 2
      - id: distance
        type: f4

  ik_frame:
    doc: Model display and IK on/off keyframe (added in MMD 7.40).
    seq:
      - id: frame_number
        type: u4
      - id: visible
        type: u1
      - id: ik_state_count
        type: u4
      - id: ik_states
        type: ik_state
        repeat: expr
        repeat-expr: ik_state_count

  ik_state:
    seq:
      - id: name
        size: 20
        type: strz
      - id: enabled
        type: u1

  vec3:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4

  vec4:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4
      - id: w
        type: f4
