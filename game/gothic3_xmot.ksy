# Imported from https://github.com/georgeto/g3blend/blob/e4f64a496d774263efcd299206489434ab5762d9/doc/xmot.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gothic3_xmot
  title: Gothic 3 animation motion
  file-extension: xmot
  license: GPL-3.0-only
  imports:
    - genomfle
  encoding: windows-1252
  endian: le
doc: Gothic 3 animation motion format
seq:
  - id: meta
    type: genomfle
  - id: version
    type: u2
  - id: resource_size
    type: u4
  - id: resource_priority
    type: f4
  - id: native_file_time
    type: u8 # bCDateTime
  - id: native_file_size
    type: u4
  - id: unk_file_time
    type: u8 # bCDateTime
    if: version >= 3
  - id: num_frame_effects
    type: u2
    if: version >= 2
  - id: frame_effects
    type: frame_effect
    repeat: expr
    repeat-expr: num_frame_effects
    if: version >= 2
  - id: motion
    type: emfx2_motion
  
types:
  frame_effect:
    seq:
      - id: key_frame
        type: u2
      - id: effect_name
        type: string
        
  emfx2_motion: # TODO: This is eCWrapper... (maybe extract later)
    seq:
      - id: size
        type: u4
      - id: magic
        contents: 'LMA '
      - id: high_version
        contents: [1]
      - id: low_version
        contents: [1]
      - id: is_actor # is this an actor? (if false, it is an actor)
        contents: [0]
      - id: chunks
        size: size - 7
        type: chunks
  
  chunks:
    seq:
      - id: chunks
        type: chunk
        repeat: eos
  
  chunk:
    seq:
      - id: chunk_id
        type: u4
        enum: lma_chunk_id
      - id: chunk_size
        type: u4
      - id: version
        type: u4
      - id: content
        size: chunk_size
        type:
          switch-on: chunk_id
          cases:
            'lma_chunk_id::motionpart': cnk_motion_part
            'lma_chunk_id::anim': cnk_key_frame

  cnk_motion_part:
    seq:
      - id: version_guard
        size: 0
        process: report_wrong_version
        if: _parent.version != 3
      - id: pose_position       # initial pose position
        type: vector
      - id: pose_rotation       # initial pose rotation
        type: quaternion
      - id: pose_scale          # initial pose scale
        type: vector
      - id: bind_pose_position  # initial pose position
        type: vector
      - id: bind_pose_rotation  # initial pose rotation
        type: quaternion
      - id: bind_pose_scale     # initial pose scale
        type: vector
      - id: name 
        type: lma_string

  cnk_key_frame:
    seq:
      - id: version_guard
        size: 0
        process: report_wrong_version
        if: _parent.version != 1
      - id: num_frames
        type: u4
      - id: interpolation_type
        size: 1
        type: str
        doc: |
          L -> Linear
          B -> Bezier
          T -> TCB
      - id: animation_type
        size: 1
        type: str
        doc: |
          P -> Position
          R -> Rotation
          S -> Scaling
      - id: reserverd
        type: u2
      - id: frames
        type:
          switch-on: animation_type
          cases:
            "'P'": vector_key_frame
            "'R'": quaternion_key_frame
            "'S'": vector_key_frame
        repeat: expr
        repeat-expr: num_frames

  vector_key_frame:
    seq:
      - id: time
        type: f4
      - id: value
        type: vector

  quaternion_key_frame:
    seq:
      - id: time
        type: f4
      - id: value
        type: quaternion



  cnk_unknown:
    seq:
      - id: data
        size-eos: true

  lma_string:
    seq:
      - id: len
        type: u4
      - id: data
        size: len
        type: str

  vector:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4  
      - id: z
        type: f4

  quaternion:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4  
      - id: z
        type: f4
      - id: w
        type: f4

  string:
    seq:
      - id: strtab_index
        type: u2

enums:
  lma_chunk_id:
    0: node                   # a node (LMA_Node) coming up next
    1: motionpart             # a motion part (LMA_MotionPart) coming up next
    2: anim                   # an animation (LMA_Anim) coming up next
    3: mesh                   # a mesh (LMA_Mesh) coming up next
    4: skinninginfo           # skinning information (LMA_SkinInfluence)
    5: collisionmesh          # a collision mesh
    6: material               # a material (LMA_Material)
    7: materiallayer          # a material layer (LMA_MaterialLayer)
    8: limit                  # a node limit information
    9: physicsinfo            # physic information
    10: meshexpressionpart    # a mesh expression part
    11: expressionmotionpart  # a expression motion part
    12: phonememotiondata     # list of phonemes and keyframe data
    13: fxmaterial            # a FX material
    16: scene_info            # scene info
