# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/tusc.ksy
meta:
  id: groove_coaster_tusc
  title: Groove Coaster model scene/animation data
  license: LicenseRef-All-Rights-Reserved
  imports:
    - groove_coaster_str_container
  endian: be
doc: |
  Recovered from MtxModelScene::LoadSceneData and the envelope consumers in
  MtxModelSceneItem::GetMotion and MtxModelEnvelopeInfo::GetValue. Each node
  normally has nine tracks ordered as rotation XYZ, translation XYZ, then
  scale XYZ.
seq:
  - { id: frames_per_second, type: u4 }
  - { id: first_frame, type: u4 }
  - { id: last_frame, type: u4 }
  - id: unknown_0c
    type: u4
    doc: Always 1 in the 71 gc2 samples; no consumer semantics proven.
  - id: num_nodes
    type: u4
  - id: nodes
    type: scene_node
    repeat: expr
    repeat-expr: num_nodes
types:
  scene_node:
    seq:
      - { id: name, type: groove_coaster_str_container }
      - id: bone_index
        type: u4
        doc: Index of the TUMO bone animated by this node.
      - id: num_tracks
        type: u4
      - id: tracks
        type: animation_track
        repeat: expr
        repeat-expr: num_tracks
  animation_track:
    seq:
      - id: pre_behavior
        type: u4
        doc: Envelope behavior before the first key.
      - id: post_behavior
        type: u4
        doc: Envelope behavior after the last key.
      - id: num_keyframes
        type: u4
      - id: keyframes
        type: keyframe
        repeat: expr
        repeat-expr: num_keyframes
  keyframe:
    seq:
      - id: shape
        type: u4
        enum: key_shapes
      - { id: time, type: f4 }
      - { id: value, type: f4 }
      - { id: param_0, type: f4 }
      - { id: param_1, type: f4 }
      - { id: param_2, type: f4 }
      - { id: param_3, type: f4 }
      - { id: param_4, type: f4 }
      - { id: param_5, type: f4 }
enums:
  key_shapes:
    0: tcb
    1: hermite
    2: bezier_1
    3: linear
    4: step
    5: bezier_2
